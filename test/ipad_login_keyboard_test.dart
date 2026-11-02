import 'dart:convert';
import 'dart:io';

import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final strings = Strings(
    jsonDecode(File('assets/l10n/en.json').readAsStringSync()),
  );

  for (final size in [const Size(820, 1180), const Size(1180, 820)]) {
    for (final mode in ['login', 'create']) {
      testWidgets('iPad $size $mode keeps fields focused as keyboard opens', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetViewInsets);

        await tester.pumpWidget(
          MaterialApp(
            home: SignIn(
              mode: mode,
              strings: strings,
              firebaseReady: false,
              onOpen: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        final email = find.byKey(const Key('parent-email-field'));
        final password = find.byKey(const Key('parent-password-field'));
        await tester.ensureVisible(email);
        await tester.tap(email);
        await tester.pump();
        expect(
          tester
              .widget<EditableText>(
                find.descendant(of: email, matching: find.byType(EditableText)),
              )
              .focusNode
              .hasFocus,
          isTrue,
        );

        // In portrait, the keyboard can make the Scaffold body shorter than
        // it is wide. The layout must not switch modes and replace the active
        // text field when that happens.
        tester.view.viewInsets = const FakeViewPadding(bottom: 470);
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<EditableText>(
                find.descendant(of: email, matching: find.byType(EditableText)),
              )
              .focusNode
              .hasFocus,
          isTrue,
        );
        await tester.enterText(email, 'review@example.com');
        await tester.ensureVisible(password);
        await tester.tap(password);
        await tester.pump();
        expect(
          tester
              .widget<EditableText>(
                find.descendant(
                  of: password,
                  matching: find.byType(EditableText),
                ),
              )
              .focusNode
              .hasFocus,
          isTrue,
        );
        await tester.enterText(password, 'test-password');
        expect(
          tester.widget<TextField>(email).controller!.text,
          'review@example.com',
        );
        expect(
          tester.widget<TextField>(password).controller!.text,
          'test-password',
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}
