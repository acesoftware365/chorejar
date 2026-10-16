import 'child_invitation.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import '../models/family.dart';
import 'money.dart';

abstract class FamilyRepository {
  bool get local;
  bool get parent;
  String get currency;
  String get country;
  Stream<List<ChildData>> watch();
  Future<void> create(ChildData child);
  Future<void> deleteChild(String childId);
  Future<void> change(String id, void Function(ChildData) edit);
  Future<void> submit(String childId, String taskId);
  Future<void> requestCashOut(String childId, int amount);
  Future<String> invite(String childId);
  Future<void> revoke(String childId);
  Future<void> close();
}

class LocalRepository implements FamilyRepository {
  final File file;
  @override
  final String currency;
  @override
  final String country;
  @override
  bool get local => true;
  @override
  bool get parent => true;
  Map<String, ChildData> _children = {};
  final _events = StreamController<List<ChildData>>.broadcast();
  Future<void> _queue = Future.value();
  LocalRepository(this.file, this.currency, {String? country})
    : country = country ?? countryForCurrency(currency);
  static Future<LocalRepository> open(
    String currency, {
    String? country,
  }) async {
    final dir = await getApplicationSupportDirectory();
    return fromFile(
      File('${dir.path}/chorejar-preview.json'),
      currency,
      country: country,
    );
  }

  static Future<LocalRepository> fromFile(
    File file,
    String currency, {
    String? country,
  }) async {
    var children = <String, ChildData>{};
    if (await file.exists()) {
      final json = object(jsonDecode(await file.readAsString()));
      children = json.map((k, v) => MapEntry(k, ChildData.fromJson(object(v))));
    }
    final r = LocalRepository(
      file,
      children.isEmpty ? currency : children.values.first.currency,
      country: country,
    );
    r._children = children;
    return r;
  }

  List<ChildData> get _values => _children.values.map((c) => c.copy()).toList();
  @override
  Stream<List<ChildData>> watch() async* {
    yield _values;
    yield* _events.stream;
  }

  Future<void> _write(void Function(Map<String, ChildData>) edit) {
    final done = Completer<void>();
    _queue = _queue.then((_) async {
      try {
        final next = _children.map((k, v) => MapEntry(k, v.copy()));
        edit(next);
        for (final c in next.values) {
          c.validate();
        }
        await file.parent.create(recursive: true);
        final temp = File('${file.path}.tmp');
        await temp.writeAsString(
          jsonEncode(next.map((k, v) => MapEntry(k, v.toJson()))),
          flush: true,
        );
        await temp.rename(file.path);
        _children = next;
        _events.add(_values);
        done.complete();
      } catch (e, st) {
        done.completeError(e, st);
      }
    });
    return done.future;
  }

  @override
  Future<void> create(ChildData child) => _write((all) {
    require(!all.containsKey(child.id));
    all[child.id] = child;
  });

  @override
  Future<void> deleteChild(String childId) => _write((all) {
    require(all.containsKey(childId));
    all.remove(childId);
  });
  @override
  Future<void> change(String id, void Function(ChildData) edit) =>
      _write((all) {
        require(all.containsKey(id));
        edit(all[id]!);
      });
  @override
  Future<void> submit(String childId, String taskId) =>
      change(childId, (c) => c.submit(taskId, DateTime.now()));
  @override
  Future<void> requestCashOut(String childId, int amount) =>
      change(childId, (c) => c.requestCashOut(amount));
  @override
  Future<String> invite(String childId) async => throw DomainError('cloudOnly');
  @override
  Future<void> revoke(String childId) async => throw DomainError('cloudOnly');
  @override
  Future<void> close() => _events.close();
}

class CloudRepository implements FamilyRepository {
  final FirebaseFirestore db;
  final String owner;
  final String? linkedChild;
  @override
  final String currency;
  @override
  final String country;
  CloudRepository({
    required this.owner,
    required this.currency,
    String? country,
    this.linkedChild,
    FirebaseFirestore? firestore,
  }) : country = country ?? countryForCurrency(currency),
       db = firestore ?? FirebaseFirestore.instance;
  @override
  bool get local => false;
  @override
  bool get parent => linkedChild == null;
  CollectionReference<Map<String, dynamic>> get children =>
      db.collection('families').doc(owner).collection('children');
  @override
  Stream<List<ChildData>> watch() {
    if (parent) {
      return children.snapshots().map(
        (s) => s.docs.map((d) => ChildData.fromJson(d.data())).toList(),
      );
    }
    final ref = children.doc(linkedChild);
    late StreamController<List<ChildData>> output;
    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? live;
    Timer? timer;
    var closed = false, fallback = false;
    List<ChildData> profile(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
        snapshot.exists ? [ChildData.fromJson(snapshot.data()!)] : [];
    Future<void> pollAuthorizedProfile() async {
      try {
        final snapshot = await db.runTransaction((tx) => tx.get(ref));
        if (closed) return;
        output.add(profile(snapshot));
        timer = Timer(const Duration(seconds: 10), pollAuthorizedProfile);
      } catch (error, stack) {
        if (closed) return;
        output.addError(error, stack);
        await output.close();
      }
    }

    output = StreamController<List<ChildData>>(
      onListen: () {
        live = ref.snapshots().listen(
          (snapshot) {
            if (!closed && !fallback && !snapshot.metadata.isFromCache) {
              output.add(profile(snapshot));
            }
          },
          onError: (Object error, StackTrace stack) {
            if (closed) return;
            if (error is FirebaseException &&
                error.code == 'permission-denied' &&
                !fallback) {
              // Some production listener reads reject rule dependencies while an
              // authorized server transaction succeeds. Preserve the same rules;
              // revocation still fails the transaction and clears the screen.
              fallback = true;
              live?.cancel();
              pollAuthorizedProfile();
            } else {
              output.addError(error, stack);
            }
          },
        );
      },
      onCancel: () async {
        closed = true;
        timer?.cancel();
        await live?.cancel();
      },
    );
    return output.stream;
  }

  @override
  Future<void> create(ChildData child) async {
    require(parent, 'permission');
    child.validate();
    await db.runTransaction((tx) async {
      final ref = children.doc(child.id);
      final old = await tx.get(ref);
      require(!old.exists, 'duplicate');
      tx.set(ref, {...child.toJson(), 'country': country});
    });
  }

  @override
  Future<void> change(String id, void Function(ChildData) edit) async {
    require(parent, 'permission');
    await db.runTransaction((tx) async {
      final ref = children.doc(id);
      final snap = await tx.get(ref);
      require(snap.exists);
      final child = ChildData.fromJson(snap.data()!);
      edit(child);
      child.validate();
      tx.set(ref, {...child.toJson(), 'country': country});
    });
  }

  Future<void> chooseGoal(
    String childId,
    String name,
    String image,
    int amount,
  ) async {
    require(parent || linkedChild == childId, 'permission');
    require(
      name.trim().isNotEmpty &&
          name.length <= 120 &&
          amount > 0 &&
          amount <= 1000000000,
    );
    await db.runTransaction((tx) async {
      final ref = children.doc(childId);
      final snap = await tx.get(ref);
      require(snap.exists, 'permission');
      final child = ChildData.fromJson(snap.data()!);
      child.goalName = name.trim();
      child.goalImage = image;
      child.goalAmount = amount;
      child.validate();
      tx.update(ref, {
        'goalName': child.goalName,
        'goalImage': image,
        'goalAmount': amount,
      });
    });
  }

  @override
  Future<void> submit(String childId, String taskId) async {
    require(!parent && linkedChild == childId, 'permission');
    await db.runTransaction((tx) async {
      final ref = children.doc(childId);
      final snap = await tx.get(ref);
      require(snap.exists);
      final c = ChildData.fromJson(snap.data()!);
      c.submit(taskId, DateTime.now());
      tx.update(ref, {
        'tasks.$taskId.status': 'review',
        'lastSubmitted': taskId,
      });
    });
  }

  @override
  Future<void> requestCashOut(String childId, int amount) async {
    require(!parent && linkedChild == childId, 'permission');
    await db.runTransaction((tx) async {
      final ref = children.doc(childId);
      final snap = await tx.get(ref);
      require(snap.exists, 'permission');
      final child = ChildData.fromJson(snap.data()!);
      child.requestCashOut(amount);
      tx.update(ref, {'cashOutRequest': child.cashOutRequest});
    });
  }

  @override
  Future<String> invite(String childId) async {
    require(parent, 'permission');
    final code = newId();
    final child = await children.doc(childId).get();
    require(child.exists, 'permission');
    await db.collection('invites').doc(code).set({
      'owner': owner,
      'childId': childId,
      'claimedBy': '',
      'accessVersion': child.data()!['accessVersion'] ?? 0,
      'expires': Timestamp.fromDate(
        DateTime.now().add(const Duration(minutes: 10)),
      ),
    });
    return code;
  }

  @override
  Future<void> revoke(String childId) async {
    require(parent, 'permission');
    await change(childId, (child) => child.accessVersion++);
    final links = await db
        .collection('links')
        .where('owner', isEqualTo: owner)
        .where('childId', isEqualTo: childId)
        .get();
    final invites = await db
        .collection('invites')
        .where('owner', isEqualTo: owner)
        .where('childId', isEqualTo: childId)
        .get();
    for (final doc in [...links.docs, ...invites.docs]) {
      await doc.reference.delete();
    }
  }

  bool get familyOwner =>
      parent && FirebaseAuth.instance.currentUser?.uid == owner;

  Future<String?> secondParent() async {
    require(parent, 'permission');
    final slot = await db.collection('parentMembers').doc(owner).get();
    return slot.data()?['uid'] as String?;
  }

  Future<String> inviteParent() async {
    require(familyOwner, 'permission');
    require(await secondParent() == null, 'twoParentsFull');
    final code = newId();
    await db.collection('parentInvites').doc(code).set({
      'owner': owner,
      'claimedBy': '',
      'expires': Timestamp.fromDate(
        DateTime.now().add(const Duration(minutes: 10)),
      ),
    });
    return code;
  }

  Future<void> removeParent() async {
    require(parent, 'permission');
    await db.runTransaction((tx) async {
      final slot = db.collection('parentMembers').doc(owner);
      final snap = await tx.get(slot);
      if (!snap.exists) return;
      tx.delete(
        db.collection('parentLinks').doc(snap.data()!['uid'] as String),
      );
      tx.delete(slot);
    });
    // Cancel any unclaimed invitations, too.
    if (familyOwner) {
      final invites = await db
          .collection('parentInvites')
          .where('owner', isEqualTo: owner)
          .get();
      for (final invite in invites.docs) {
        await invite.reference.delete();
      }
    }
  }

  static Future<CloudRepository> joinParent(String raw) async {
    final code = ChildInvitation.parse(raw);
    require(code != null, 'invalidCode');
    final user = FirebaseAuth.instance.currentUser!;
    require(!user.isAnonymous, 'permission');
    require(await resume() == null, 'alreadyFamily');
    final db = FirebaseFirestore.instance;
    await db.runTransaction((tx) async {
      final ref = db.collection('parentInvites').doc(code);
      final snap = await tx.get(ref);
      require(snap.exists, 'invalidCode');
      final invite = snap.data()!;
      require(
        invite['claimedBy'] == '' &&
            (invite['expires'] as Timestamp).toDate().isAfter(DateTime.now()),
        'invalidCode',
      );
      tx.set(db.collection('parentMembers').doc(invite['owner'] as String), {
        'uid': user.uid,
        'invite': code,
      });
      tx.set(db.collection('parentLinks').doc(user.uid), {
        'owner': invite['owner'],
        'invite': code,
      });
      tx.update(ref, {'claimedBy': user.uid});
    });
    return (await resume())!;
  }

  @override
  Future<void> close() async {}
  static Future<CloudRepository?> resume() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final db = FirebaseFirestore.instance;
    if (user.isAnonymous) {
      // Use a server transaction instead of the listener-backed .get(): it also
      // reads the pairing and profile from one consistent, authorized snapshot.
      return db.runTransaction((tx) async {
        final link = await tx.get(db.collection('links').doc(user.uid));
        if (!link.exists) return null;
        final data = link.data()!;
        final child = await tx.get(
          db
              .collection('families')
              .doc(data['owner'])
              .collection('children')
              .doc(data['childId']),
        );
        require(child.exists, 'permission');
        return CloudRepository(
          owner: data['owner'],
          linkedChild: data['childId'],
          currency: child.data()!['currency'],
          country:
              child.data()!['country'] as String? ??
              countryForCurrency(child.data()!['currency'] as String),
        );
      });
    }
    final membership = await db.collection('parentLinks').doc(user.uid).get();
    final owner = membership.data()?['owner'] as String? ?? user.uid;
    final family = await db.collection('families').doc(owner).get();
    if (!family.exists) return null;
    final familyData = family.data()!;
    final familyCurrency = familyData['currency'] as String;
    return CloudRepository(
      owner: owner,
      currency: familyCurrency,
      country:
          familyData['country'] as String? ??
          countryForCurrency(familyCurrency),
    );
  }

  static Future<CloudRepository> setup(String currency, String country) async {
    final u = FirebaseAuth.instance.currentUser!;
    require(!u.isAnonymous, 'permission');
    final db = FirebaseFirestore.instance;
    await db.runTransaction((tx) async {
      final ref = db.collection('families').doc(u.uid);
      final old = await tx.get(ref);
      if (!old.exists) {
        tx.set(ref, {
          'currency': currency,
          'country': country,
          'created': FieldValue.serverTimestamp(),
        });
      }
    });
    return (await resume())!;
  }

  static Future<CloudRepository> pair(String raw) async {
    final code = ChildInvitation.parse(raw);
    require(code != null, 'invalidCode');
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null && !auth.currentUser!.isAnonymous) {
      throw DomainError('signOutFirst');
    }
    final user = auth.currentUser ?? (await auth.signInAnonymously()).user!;
    final db = FirebaseFirestore.instance;
    try {
      await db.runTransaction((tx) async {
        final link = db.collection('links').doc(user.uid);
        final existing = await tx.get(link);
        if (existing.data()?['invite'] == code) return;
        final inviteRef = db.collection('invites').doc(code);
        final snap = await tx.get(inviteRef);
        require(snap.exists, 'invalidCode');
        final i = snap.data()!;
        require(i['claimedBy'] == '', 'invalidCode');
        if (existing.exists) {
          final old = existing.data()!;
          require(
            old['owner'] == i['owner'] &&
                old['childId'] == i['childId'] &&
                old['accessVersion'] == i['accessVersion'],
            'alreadyLinked',
          );
          // Recover a pairing saved by an earlier attempt without consuming the
          // parent's new invitation or replacing this device's existing access.
          return;
        }
        // Expiration is enforced by Firebase's clock in the read and commit rules.
        tx.set(link, {
          'owner': i['owner'],
          'childId': i['childId'],
          'invite': code,
          'accessVersion': i['accessVersion'],
        });
        tx.update(inviteRef, {'claimedBy': user.uid});
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied' || e.code == 'not-found') {
        throw DomainError('invalidCode');
      }
      rethrow;
    }
    try {
      final linked = await resume();
      require(linked != null, 'pairLoadRetry');
      return linked!;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw DomainError('pairAccessRemoved');
      // The committed link remains usable when retrying after a lost connection.
      if (e.code == 'unavailable' || e.code == 'deadline-exceeded') {
        throw DomainError('pairLoadRetry');
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteChild(String childId) async {
    require(parent, 'permission');
    // Disable existing sessions before deleting this profile and its embedded history.
    await revoke(childId);
    await children.doc(childId).delete();
  }

  Future<void> deleteFamily() async {
    require(familyOwner, 'permission');
    await removeParent();
    // Reauthentication is performed by the caller before deletion.
    final childDocs = await children.get();
    for (final child in childDocs.docs) {
      await revoke(child.id);
      await child.reference.delete();
    }
    await db.collection('families').doc(owner).delete();
    await FirebaseAuth.instance.currentUser!.delete();
  }
}
