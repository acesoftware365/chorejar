import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chorejar/services/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:chorejar/main.dart';
import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/models/family.dart';
import 'package:chorejar/screens/sign_in.dart';
import 'package:chorejar/widgets/child_invitation_dialog.dart';
import 'widget_test.dart' show MemoryRepository;

class LinkableRepository extends MemoryRepository {
  String? invited;
  @override
  bool get local => false;
  @override
  Future<String> invite(String id) async {
    invited = id;
    return '0123456789abcdef0123456789abcdef';
  }
}

class UnusedFirestore extends Fake implements FirebaseFirestore {}

class ParentAccessRepository extends CloudRepository {
  ParentAccessRepository()
    : super(owner: 'test', currency: 'USD', firestore: UnusedFirestore());
  int invitations = 0;
  @override
  bool get familyOwner => true;
  @override
  Stream<List<ChildData>> watch() =>
      Stream.value([ChildData(id: 'a', name: 'Alex', currency: 'USD')]);
  @override
  Future<String?> secondParent() async => null;
  @override
  Future<String> inviteParent() async {
    invitations++;
    return '0123456789abcdef0123456789abcdef';
  }
}

void main() {
  Strings strings(String lang) =>
      Strings(jsonDecode(File('assets/l10n/$lang.json').readAsStringSync()));
  Future<void> open(
    WidgetTester tester,
    MemoryRepository repo,
    Strings s,
  ) async {
    SharedPreferences.setMockInitialValues({'language': 'es'});
    repo.values['a'] = ChildData(id: 'a', name: 'Alex', currency: 'USD');
    await tester.pumpWidget(
      ChoreJar(
        prefs: await SharedPreferences.getInstance(),
        initialStrings: s,
        initialRepository: repo,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'A51 parent layout keeps pairing and first task in reach with larger text',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 800);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final s = strings('en');
      final repo = MemoryRepository();
      await open(tester, repo, s);
      await repo.change(
        'a',
        (child) => child.addTask(
          Task(
            id: 'task',
            title: 'Put away toys',
            amount: 500,
            frequency: 'weekly',
            due: '2026-10-11',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('link-child-device')).hitTestable(),
        findsOneWidget,
      );
      expect(find.text('Put away toys').hitTestable(), findsOneWidget);
      expect(tester.getTopLeft(find.text('Put away toys')).dy, lessThan(550));
      expect(
        find.text(s('allowance')),
        findsNothing,
      ); // An unconfigured allowance has no card.
      expect(
        tester.getSize(find.byKey(const Key('compact-parent-profile'))).height,
        lessThan(145),
      );
      await tester.tap(find.byKey(const Key('profile-actions')));
      await tester.pumpAndSettle();
      expect(find.text(s('editChild')).hitTestable(), findsOneWidget);
      expect(find.text(s('childView')).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Visible settings, connection instructions and parent login fit small and wide screens',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      for (final lang in ['es', 'en']) {
        for (final size in [
          const Size(320, 568),
          const Size(384, 760),
          const Size(951, 669),
        ]) {
          tester.view.physicalSize = size;
          tester.platformDispatcher.textScaleFactorTestValue = size.width == 320
              ? 2
              : 1;
          final s = strings(lang);
          await open(tester, MemoryRepository(), s);
          expect(find.text(s('settings')).hitTestable(), findsOneWidget);
          await tester.tap(find.byKey(const Key('open-settings')));
          await tester.pumpAndSettle();
          expect(find.text(s('familyConnections')), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.scrollUntilVisible(
            find.text(s('twoParents')),
            150,
            scrollable: find.byType(Scrollable).last,
          );
          await Scrollable.ensureVisible(
            tester.element(find.text(s('twoParents'))),
            alignment: 0.5,
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text(s('twoParents')));
          await tester.pumpAndSettle();
          expect(find.text(s('parentPreviewHelp')), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.tap(find.text(s('cancel')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('open-settings')));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text(s('link')));
          await tester.tap(find.text(s('link')));
          await tester.pumpAndSettle();
          expect(find.text(s('linkPreviewHelp')), findsOneWidget);
          expect(find.byType(QrImageView), findsNothing);
          expect(tester.takeException(), isNull);
          await tester.tap(find.text(s('accountStart')));
          await tester.pumpAndSettle();
          expect(find.byType(SignIn), findsOneWidget);
          await tester.scrollUntilVisible(
            find.widgetWithText(TextField, s('password')),
            160,
            scrollable: find.byType(Scrollable).first,
          );
          expect(find.widgetWithText(TextField, s('password')), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
        }
      }
    },
  );

  testWidgets('Direct linking creates QR only for the selected child', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final repo = LinkableRepository();
    repo.values['b'] = ChildData(id: 'b', name: 'Sam', currency: 'USD');
    final s = strings('es');
    await open(tester, repo, s);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Alex'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('link-child-device')));
    await tester.pumpAndSettle();
    expect(repo.invited, 'a');
    expect(
      tester
          .widget<ChildInvitationDialog>(find.byType(ChildInvitationDialog))
          .childName,
      'Alex',
    );
    expect(find.byType(QrImageView), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text(s('close')));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'Child preview settings do not expose parent account or family controls',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(384, 760);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final s = strings('es');
      await open(tester, MemoryRepository(), s);
      await tester.tap(find.byKey(const Key('profile-actions')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(s('childView')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('open-settings')));
      await tester.pumpAndSettle();
      expect(find.text(s('yourDevice')), findsOneWidget);
      for (final label in [
        'link',
        'twoParents',
        'membership',
        'deleteAccount',
        'manageProfile',
        'accountStart',
      ]) {
        expect(find.text(s(label)), findsNothing);
      }
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'Second-parent invitation remains actionable after opening settings',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(440, 956);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      SharedPreferences.setMockInitialValues({'language': 'es'});
      final s = strings('es');
      final repo = ParentAccessRepository();
      await tester.pumpWidget(
        ChoreJar(
          prefs: await SharedPreferences.getInstance(),
          initialStrings: s,
          initialRepository: repo,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('open-settings')));
      await tester.pumpAndSettle();
      await Scrollable.ensureVisible(
        tester.element(find.text(s('twoParents'))),
        alignment: 0.5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(s('twoParents')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, s('inviteParent')));
      await tester.pumpAndSettle();
      expect(repo.invitations, 1);
      expect(find.text(s('shareInvitation')), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(s('confirm')));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
    },
  );
}
