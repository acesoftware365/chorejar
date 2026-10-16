import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:chorejar/services/child_invitation.dart';
import 'package:chorejar/services/parent_invitation.dart';
import 'package:chorejar/widgets/child_invitation_dialog.dart';
import 'package:chorejar/screens/welcome_flow.dart';
import 'package:chorejar/l10n/strings.dart';

void main() {
  const code = '0123456789abcdef0123456789abcdef';
  test('Child codes and shared messages accept only child links', () {
    expect(ChildInvitation.parse(code.toUpperCase()), code);
    expect(
      ChildInvitation.parse(
        'Open this link:\n${ChildInvitation.link(code)}\nCode: $code',
      ),
      code,
    );
    for (final value in [
      ParentInvitation.link(code),
      'https://example.com/?code=$code',
      'chorejar://join-child/extra?code=$code',
      'chorejar://join-child?code=123',
      'bad',
    ]) {
      expect(ChildInvitation.parse(value), isNull);
    }
    expect(ParentInvitation.parse(ChildInvitation.link(code)), isNull);
    expect(ChildInvitation.parse('chorejar://join-child?code=$code'), code);
    expect(
      ChildInvitation.parse(
        'https://chorejar-liisgo-2026.web.app/join-child#code=$code',
      ),
      code,
    );
    for (final invalid in [
      'https://chorejar-liisgo-2026.web.app.evil.com/join-child#code=$code',
      'https://evil.com/join-child#code=$code',
      'https://chorejar-liisgo-2026.web.app/join-parent#code=$code',
      'https://chorejar-liisgo-2026.web.app/join-child#code=%',
      'https://chorejar-liisgo-2026.web.app/join-child#code=$code&bad=%',
    ]) {
      expect(ChildInvitation.parse(invalid), isNull);
    }
  });
  test('Share text places a complete HTTPS link in its own paragraph', () {
    final message = ChildInvitation.message('Open ChoreJar', code, 'Code:');
    expect(
      message,
      'Open ChoreJar\n\n${ChildInvitation.link(code)}\n\nCode:\n$code',
    );
    expect(ChildInvitation.parse(message), code);
    final uri = Uri.parse(message.split('\n\n')[1]);
    expect(uri.scheme, 'https');
    expect(
      uri.query,
      isEmpty,
    ); // Token stays in the fragment, out of hosting requests.
  });
  testWidgets(
    'Child link opens child pairing, never second-parent account form',
    (tester) async {
      final strings = Strings(
        jsonDecode(File('assets/l10n/es.json').readAsStringSync()),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: WelcomeFlow(
            strings: strings,
            firebaseReady: false,
            invitation: code,
            childInvitation: true,
            onOpen: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        code,
      );
      expect(find.text(strings('childCodeOrLink')), findsOneWidget);
      expect(find.text(strings('password')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'QR and sharing dialog fits small phones, large text and tablets',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      for (final lang in ['es', 'en']) {
        final strings = Strings(
          jsonDecode(File('assets/l10n/$lang.json').readAsStringSync()),
        );
        for (final size in [
          const Size(320, 568),
          const Size(669, 951),
          const Size(951, 669),
        ]) {
          tester.view.physicalSize = size;
          tester.platformDispatcher.textScaleFactorTestValue = size.width == 320
              ? 2
              : 1;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ChildInvitationDialog(code: code, strings: strings),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byType(QrImageView), findsOneWidget);
          expect(find.text(strings('childSendLink')), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
        }
      }
    },
  );
}
