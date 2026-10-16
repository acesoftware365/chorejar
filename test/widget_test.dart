import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chorejar/main.dart';
import 'package:chorejar/screens/sign_in.dart';
import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/models/family.dart';
import 'package:chorejar/services/repository.dart';

class MemoryRepository implements FamilyRepository {
  final updates = StreamController<List<ChildData>>.broadcast();
  final values = <String, ChildData>{};
  @override
  bool get local => true;
  @override
  bool get parent => true;
  @override
  String get currency => 'USD';
  @override
  String get country => 'US';
  @override
  Stream<List<ChildData>> watch() async* {
    yield values.values.toList();
    yield* updates.stream;
  }

  @override
  Future<void> change(String id, void Function(ChildData) edit) async {
    final next = values[id]!.copy();
    edit(next);
    next.validate();
    values[id] = next;
    updates.add(values.values.toList());
  }

  @override
  Future<void> create(ChildData c) async {
    c.validate();
    values[c.id] = c;
    updates.add(values.values.toList());
  }

  @override
  Future<void> submit(String c, String t) =>
      change(c, (v) => v.submit(t, DateTime.now()));
  @override
  Future<String> invite(String id) async => 'preview';
  @override
  Future<void> deleteChild(String childId) async {
    values.remove(childId);
    updates.add(values.values.toList());
  }

  @override
  Future<void> revoke(String id) async {}
  @override
  Future<void> close() async {
    if (!updates.isClosed) await updates.close();
  }
}

void main() {
  testWidgets(
    'Money summary hides secondary actions until details are opened',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(440, 956);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'language': 'es'});
      final repo = MemoryRepository();
      repo.values['a'] = ChildData(id: 'a', name: 'Alex', currency: 'USD');
      final strings = Strings(
        jsonDecode(File('assets/l10n/es.json').readAsStringSync()),
      );
      await tester.pumpWidget(
        ChoreJar(
          prefs: await SharedPreferences.getInstance(),
          initialRepository: repo,
          initialStrings: strings,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(strings('money')));
      await tester.pumpAndSettle();
      for (final width in [669.0, 951.0, 466.0]) {
        tester.view.physicalSize = Size(width, 678);
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('wide-parent-layout')),
          width >= 640 ? findsOneWidget : findsNothing,
        );
        expect(find.text(strings('toGive')), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
      expect(find.text(strings('toGive')), findsOneWidget);
      expect(find.text(strings('withdraw')), findsNothing);
      expect(find.text(strings('pending')), findsNothing);
      await tester.scrollUntilVisible(
        find.text(strings('moneyDetails')),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(strings('moneyDetails')));
      await tester.pumpAndSettle();
      expect(find.text(strings('withdraw')), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('Received link prefills invitation and explains next step', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final strings = Strings(
      jsonDecode(File('assets/l10n/es.json').readAsStringSync()),
    );
    const code = '0123456789abcdef0123456789abcdef';
    await tester.pumpWidget(
      MaterialApp(
        home: SignIn(
          strings: strings,
          firebaseReady: false,
          invitation: code,
          onOpen: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Te invitaron a la familia'), findsOneWidget);
    expect(find.text(strings('invitationReady')), findsOneWidget);
    expect(find.byType(SegmentedButton<bool>), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Second parent invitation field and honest local preview are available',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(440, 956);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'language': 'es'});
      final prefs = await SharedPreferences.getInstance();
      final strings = Strings(
        jsonDecode(File('assets/l10n/es.json').readAsStringSync()),
      );
      await tester.pumpWidget(ChoreJar(prefs: prefs, initialStrings: strings));
      await tester.pumpAndSettle();
      await tester.tap(find.text(strings('joinParent')));
      await tester.pumpAndSettle();
      expect(find.text(strings('parentGateTitle')), findsOneWidget);
      await tester.tap(find.byKey(const Key('parent-access-continue')));
      await tester.pumpAndSettle();
      expect(find.text(strings('joinParentHelp')), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
      await tester.pumpWidget(const SizedBox());
      final repo = MemoryRepository();
      await tester.pumpWidget(
        ChoreJar(
          prefs: prefs,
          initialStrings: strings,
          initialRepository: repo,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(strings('settings')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(strings('twoParents')));
      await tester.pumpAndSettle();
      expect(find.text(strings('parentPreviewHelp')), findsOneWidget);
      expect(find.text(strings('shareInvitation')), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(strings('cancel')));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'Deletion warns, cancels safely and deletes only the selected child',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(440, 956);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'language': 'es'});
      final repo = MemoryRepository();
      repo.values['a'] = ChildData(id: 'a', name: 'Alex', currency: 'USD');
      repo.values['b'] = ChildData(id: 'b', name: 'Sam', currency: 'USD');
      await tester.pumpWidget(
        ChoreJar(
          prefs: await SharedPreferences.getInstance(),
          initialRepository: repo,
          initialStrings: Strings(
            jsonDecode(File('assets/l10n/es.json').readAsStringSync()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar niño'));
      await tester.pumpAndSettle();
      expect(find.text('¿Eliminar a Alex?'), findsOneWidget);
      expect(find.textContaining('No se puede deshacer'), findsOneWidget);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(repo.values.keys, containsAll(['a', 'b']));
      await tester.tap(find.text('Eliminar niño'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar definitivamente'));
      await tester.pumpAndSettle();
      expect(repo.values.keys, ['b']);
      expect(find.text('Perfil eliminado.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('Both languages and all sections fit phone/tablet and 2x text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    for (final language in ['es', 'en']) {
      for (final size in [
        const Size(320, 568),
        const Size(360, 640),
        const Size(384, 760),
        const Size(411, 731),
        const Size(466, 678),
        const Size(669, 951),
        const Size(951, 669),
        const Size(440, 956),
        const Size(1024, 1366),
      ]) {
        SharedPreferences.setMockInitialValues({'language': language});
        final repo = MemoryRepository();
        final c = ChildData(
          id: 'a',
          name: 'Alex',
          currency: 'USD',
          goalName: 'Bicicleta',
          goalAmount: 10000,
        );
        c.addTask(
          Task(
            id: 't',
            title: 'Ordenar mi habitación',
            instructions: 'Guarda los juguetes.',
            amount: 200,
            due: day(DateTime.now()),
          ),
        );
        repo.values[c.id] = c;
        tester.view.physicalSize = size;
        tester.platformDispatcher.textScaleFactorTestValue = size.width == 320
            ? 2
            : 1;
        await tester.pumpWidget(
          ChoreJar(
            prefs: await SharedPreferences.getInstance(),
            initialRepository: repo,
            initialStrings: Strings(
              jsonDecode(File('assets/l10n/$language.json').readAsStringSync()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        for (final label in [
          language == 'es' ? 'Mi dinero' : 'My money',
          language == 'es' ? 'Mi meta' : 'My goal',
        ]) {
          await tester.tap(find.text(label).last);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      }
    }
  });
  testWidgets('Parent creates child and task, child submits, parent approves', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({'language': 'es'});
    final repo = MemoryRepository();
    await tester.pumpWidget(
      ChoreJar(
        prefs: await SharedPreferences.getInstance(),
        initialRepository: repo,
        initialStrings: Strings(
          jsonDecode(File('assets/l10n/es.json').readAsStringSync()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Añadir hijo').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Alex');
    await tester.tap(find.text('Guardar').last);
    await tester.pumpAndSettle();
    expect(repo.values.length, 1);
    await tester.scrollUntilVisible(
      find.text('Añadir tarea'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Añadir tarea'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Leer');
    await tester.enterText(find.byType(TextField).at(2), '2.50');
    await tester.tap(find.text('Guardar').last);
    await tester.pumpAndSettle();
    final child = repo.values.values.single;
    expect(child.tasks.length, 1);
    await tester.scrollUntilVisible(
      find.text('Ver como niño'),
      -150,
      scrollable: find.byType(Scrollable).first,
    );
    await Scrollable.ensureVisible(
      tester.element(find.text('Ver como niño')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver como niño'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('¡Ya terminé!'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await Scrollable.ensureVisible(
      tester.element(find.text('¡Ya terminé!')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('¡Ya terminé!'));
    await tester.pumpAndSettle();
    expect(repo.values.values.single.tasks.values.single.status, 'review');
    await tester.scrollUntilVisible(
      find.text('Volver a padres'),
      -150,
      scrollable: find.byType(Scrollable).first,
    );
    await Scrollable.ensureVisible(
      tester.element(find.text('Volver a padres')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volver a padres'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Aprobar'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await Scrollable.ensureVisible(
      tester.element(find.text('Aprobar')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aprobar'));
    await tester.pumpAndSettle();
    expect(repo.values.values.single.pending, 250);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
