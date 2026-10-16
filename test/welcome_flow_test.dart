import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/screens/welcome_flow.dart';
import 'widget_test.dart' show MemoryRepository;

void main() {
  final strings = Strings(
    jsonDecode(File('assets/l10n/es.json').readAsStringSync()),
  );
  testWidgets(
    'Wizard validates name, preserves back navigation and saves one child and task',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(440, 956);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = MemoryRepository();
      var opened = false;
      await tester.pumpWidget(
        MaterialApp(
          home: WelcomeFlow(
            strings: strings,
            firebaseReady: false,
            previewFactory: () async => repo,
            onOpen: (_) => opened = true,
          ),
        ),
      );
      await tester.tap(find.text('Soy mamá o papá'));
      await tester.pumpAndSettle();
      expect(find.text('Paso 1 de 4'), findsOneWidget);
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      expect(find.text(strings('childNameRequired')), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Lucía');
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '2.50');
      await tester.tap(find.text('Atrás'));
      await tester.pumpAndSettle();
      expect(find.text('Lucía'), findsOneWidget);
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      expect(find.text('2.50'), findsOneWidget);
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      expect(find.text('¡Todo listo!'), findsOneWidget);
      expect(repo.values.length, 1);
      expect(repo.values.values.single.tasks.values.single.amount, 250);
      expect(opened, isFalse);
      await tester.tap(find.text(strings('goParents')));
      await tester.pumpAndSettle();
      expect(opened, isTrue);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await repo.close();
    },
  );
  testWidgets('First chore can be skipped without creating a reward', (
    tester,
  ) async {
    final repo = MemoryRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: ParentSetup(strings: strings, repository: repo, onOpen: (_) {}),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Sam');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(strings('taskLater')));
    await tester.tap(find.text(strings('taskLater')));
    await tester.pumpAndSettle();
    expect(repo.values.values.single.tasks, isEmpty);
    expect(repo.values.values.single.entries, isEmpty);
    await tester.pumpWidget(const SizedBox());
    await repo.close();
  });
}
