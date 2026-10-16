// Isolated live Firebase QA: temporary accounts only; never production entrypoint.
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chorejar/firebase_options.dart';
import 'package:chorejar/services/repository.dart';
import 'package:chorejar/models/family.dart';
import 'package:chorejar/services/child_invitation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const emulator = bool.fromEnvironment('FIREBASE_EMULATOR');
  await Firebase.initializeApp(
    options: emulator
        ? const FirebaseOptions(
            apiKey: 'demo-key',
            appId: '1:123:web:probe',
            messagingSenderId: '123',
            projectId: 'demo-chorejar-pairing',
          )
        : firebaseOptions,
  );
  if (emulator) {
    await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
  }
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  runApp(const MaterialApp(home: Probe()));
}

class Probe extends StatefulWidget {
  const Probe({super.key});
  @override
  State<Probe> createState() => _ProbeState();
}

class _ProbeState extends State<Probe> {
  String output = 'Ready';
  bool running = false;
  void log(String message) {
    if (mounted) setState(() => output += '\n$message');
  }

  Future<void> run() async {
    setState(() {
      running = true;
      output = 'Starting isolated SDK check';
    });
    final auth = FirebaseAuth.instance, db = FirebaseFirestore.instance;
    if (auth.currentUser != null) {
      log(
        'STOP: this session already has an account. Use a fresh isolated origin.',
      );
      return;
    }
    final random = Random.secure();
    final suffix = List.generate(
      20,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
    final email = 'chorejar-sdk-$suffix@example.invalid';
    final password = List.generate(
      40,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
    String? owner, code, kid, recoveryCode;
    FirebaseApp? parentApp;
    StreamSubscription<List<ChildData>>? watching;
    String stage = 'create temporary parent';
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      owner = auth.currentUser!.uid;
      stage = 'setup family';
      final repo = await CloudRepository.setup('USD', 'US');
      await repo.create(
        ChildData(id: 'probe', name: 'QA temporary', currency: 'USD'),
      );
      code = await repo.invite('probe');
      log('PASS parent creates invitation');
      await auth.signOut();
      stage = 'anonymous sign-in';
      await auth.signInAnonymously();
      kid = auth.currentUser!.uid;
      stage = 'read invitation';
      await db.collection('invites').doc(code).get();
      log('PASS anonymous reads invitation');
      stage = 'pair via actual repository';
      final linked = await CloudRepository.pair(ChildInvitation.link(code));
      log('PASS pair returned repository');
      stage = 'watch child profile';
      final children = await linked.watch().first;
      if (children.single.id != 'probe' || linked.parent) {
        throw StateError('Incorrect linked profile');
      }
      log('PASS actual SDK transaction, resume and child subscription');
      stage = 'retry same invitation';
      await CloudRepository.pair(code);
      log('PASS retry is idempotent');
      stage = 'child goal update';
      await linked.chooseGoal('probe', 'My bicycle', 'bicycle', 10000);
      log('PASS child can save a goal');
      parentApp = await Firebase.initializeApp(
        name: 'qa-parent-$suffix',
        options: Firebase.app().options,
      );
      final parentAuth = FirebaseAuth.instanceFor(app: parentApp);
      final parentDb = FirebaseFirestore.instanceFor(app: parentApp);
      if (const bool.fromEnvironment('FIREBASE_EMULATOR')) {
        await parentAuth.useAuthEmulator('127.0.0.1', 9099);
        parentDb.useFirestoreEmulator('127.0.0.1', 8080);
      }
      parentDb.settings = const Settings(persistenceEnabled: false);
      await parentAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      stage = 'recover existing pairing using a fresh shared message';
      final parentRepo = CloudRepository(
        owner: owner,
        currency: 'USD',
        firestore: parentDb,
      );
      recoveryCode = await parentRepo.invite('probe');
      await CloudRepository.pair(
        ChildInvitation.message('Open ChoreJar', recoveryCode, 'Code:'),
      );
      log('PASS fresh shared invitation recovers an existing pairing');
      final childRef = parentDb
          .collection('families')
          .doc(owner)
          .collection('children')
          .doc('probe');
      final initial = Completer<void>(),
          updated = Completer<void>(),
          revoked = Completer<void>();
      watching = linked.watch().listen(
        (items) {
          if (!initial.isCompleted) initial.complete();
          if (items.any((c) => c.name == 'QA updated') &&
              !updated.isCompleted) {
            updated.complete();
          }
        },
        onError: (Object e) {
          if (!revoked.isCompleted) revoked.complete();
        },
      );
      stage = 'parent update sync';
      await initial.future.timeout(const Duration(seconds: 25));
      await childRef.update({'name': 'QA updated'});
      await updated.future.timeout(const Duration(seconds: 25));
      log('PASS parent update reaches child');
      stage = 'access revocation';
      await childRef.update({'accessVersion': 1});
      await revoked.future.timeout(const Duration(seconds: 25));
      log('PASS revocation stops child access');
      var denied = false;
      try {
        await CloudRepository.pair(code);
      } catch (_) {
        denied = true;
      }
      if (!denied) throw StateError('Revoked access was restored');
      log('PASS retry cannot restore revoked access');
    } catch (e) {
      log(
        'FAIL $stage: ${e is FirebaseException
            ? '${e.plugin}/${e.code}: ${e.message}'
            : e is DomainError
            ? e.key
            : e.runtimeType}',
      );
      if (kid != null &&
          code != null &&
          auth.currentUser?.isAnonymous == true) {
        final link = await db.collection('links').doc(kid).get();
        log(
          'DIAG link committed: ${link.exists}, anonymous: ${auth.currentUser!.isAnonymous}',
        );
        if (!const bool.fromEnvironment('FIREBASE_EMULATOR')) {
          final token = await auth.currentUser!.getIdToken();
          final response = await http.get(
            Uri.parse(
              'https://firestore.googleapis.com/v1/projects/chorejar-liisgo-2026/databases/(default)/documents/families/$owner/children/probe',
            ),
            headers: {'Authorization': 'Bearer $token'},
          );
          log('DIAG REST child read: ${response.statusCode}');
          if (response.statusCode == 200) {
            final fields = jsonDecode(response.body)['fields'];
            log(
              'DIAG archived: ${fields['archived']}, version: ${fields['accessVersion']}, own link matches: ${link.data()?['owner'] == owner && link.data()?['childId'] == 'probe'}',
            );
          }
        }
        try {
          await db.runTransaction((tx) async {
            await tx.get(
              db
                  .collection('families')
                  .doc(owner)
                  .collection('children')
                  .doc('probe'),
            );
          });
          log('DIAG transaction child read succeeds');
        } catch (e) {
          log(
            'DIAG transaction child read: ${e is FirebaseException ? e.code : e.runtimeType}',
          );
        }
        try {
          await db
              .collection('families')
              .doc(owner)
              .collection('children')
              .doc('probe')
              .get();
          log('DIAG direct child get succeeds');
        } catch (e) {
          log(
            'DIAG direct child get: ${e is FirebaseException ? e.code : e.runtimeType}',
          );
        }
        try {
          final resumed = await CloudRepository.resume();
          log('DIAG resume succeeds, child role: ${resumed?.parent == false}');
        } catch (e) {
          log(
            'DIAG resume: ${e is FirebaseException ? e.code : e.runtimeType}',
          );
        }

        final invite = await db.collection('invites').doc(code).get();
        log(
          'DIAG invitation claimed by this device: ${invite.data()?['claimedBy'] == kid}',
        );
      }
    } finally {
      await watching?.cancel();
      if (parentApp != null) {
        await FirebaseAuth.instanceFor(app: parentApp).signOut();
        await parentApp.delete();
      }
      try {
        if (auth.currentUser?.isAnonymous == true) {
          await auth.currentUser!.delete();
        }
        if (owner != null) {
          await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (kid != null) await db.collection('links').doc(kid).delete();
          if (code != null) await db.collection('invites').doc(code).delete();
          if (recoveryCode != null) {
            await db.collection('invites').doc(recoveryCode).delete();
          }
          await db
              .collection('families')
              .doc(owner)
              .collection('children')
              .doc('probe')
              .delete();
          await db.collection('families').doc(owner).delete();
          await auth.currentUser!.delete();
        }
        log('PASS temporary accounts and documents removed');
      } catch (e) {
        log('CLEANUP FAILED: ${e.runtimeType}');
      }
      setState(() => running = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('ChoreJar pairing SDK probe'),
          FilledButton(
            onPressed: running ? null : run,
            child: const Text('Run isolated check'),
          ),
          SelectableText(output),
        ],
      ),
    ),
  );
}
