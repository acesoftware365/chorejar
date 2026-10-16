import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/widgets/editor.dart';

void main() {
  testWidgets(
    'All 18 choices scroll and save the selected goal with a matching name',
    (tester) async {
      tester.view.physicalSize = const Size(440, 956);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final strings = Strings(
        jsonDecode(File('assets/l10n/es.json').readAsStringSync()),
      );
      Map<String, String>? saved;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => editor(
                  context,
                  strings,
                  'editGoal',
                  [
                    const InputField('name', 'goalName', initial: 'Mi iPhone'),
                    const InputField(
                      'image',
                      'goalImage',
                      initial: 'iphone',
                      imageChoices: true,
                    ),
                  ],
                  (values) async {
                    saved = values;
                  },
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(ChoiceChip), findsNWidgets(18));
      await tester.scrollUntilVisible(
        find.text('Kit de arte'),
        220,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Kit de arte'));

      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Guardar'));
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(saved?['image'], 'artkit');
      expect(saved?['name'], 'Kit de arte');
      expect(tester.takeException(), isNull);
    },
  );
}
