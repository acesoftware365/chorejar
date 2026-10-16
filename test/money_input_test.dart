import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chorejar/widgets/money_input.dart';

void main() {
  testWidgets('amount clears on entry, keeps edits, and dismisses with Done', (
    tester,
  ) async {
    final controller = TextEditingController(text: '12.50');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoneyInput(
            controller: controller,
            label: 'Cantidad',
            doneLabel: 'Listo',
          ),
        ),
      ),
    );
    expect(controller.text, '12.50');
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(controller.text, isEmpty);
    var field = tester.widget<TextField>(find.byType(TextField));
    expect(
      field.keyboardType,
      const TextInputType.numberWithOptions(decimal: true),
    );
    expect(field.textInputAction, TextInputAction.done);
    await tester.enterText(find.byType(TextField), '25.75');
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(controller.text, '25.75');
    await tester.tap(find.text('Listo'));
    await tester.pumpAndSettle();
    expect(field.focusNode!.hasFocus, isFalse);
    expect(tester.testTextInput.isVisible, isFalse);
    expect(controller.text, '25.75');
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(controller.text, isEmpty);
    await tester.enterText(find.byType(TextField), '18.50');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(field.focusNode!.hasFocus, isFalse);
    expect(tester.testTextInput.isVisible, isFalse);
    expect(controller.text, '18.50');
    await tester.pumpWidget(const SizedBox());
  });
}
