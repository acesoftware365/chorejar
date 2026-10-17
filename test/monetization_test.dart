import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/screens/membership.dart';
import 'package:chorejar/services/advertising.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unavailable ads do not show a parent banner', () {
    final ads = Advertising();
    expect(ads.showBanner, isFalse);
    ads.dispose();
  });
  test('a ready parent ad service keeps the fixed banner available', () {
    final ads = Advertising()..ready = true;
    expect(ads.showBanner, isTrue);
    ads.dispose();
  });
  testWidgets('unconfigured plans keep purchase controls disabled', (
    tester,
  ) async {
    final strings = await Strings.load('es');
    await tester.pumpWidget(
      MaterialApp(
        home: MembershipScreen(strings: strings, parentAuthorized: true),
      ),
    );
    expect(find.text(strings('premiumPlan')), findsWidgets);
    final monthlyPlan = find.widgetWithText(
      FilledButton,
      strings('chooseMonthlyPlan'),
    );
    await tester.scrollUntilVisible(monthlyPlan, 160);
    final monthlyButton = tester.widget<FilledButton>(monthlyPlan);
    expect(monthlyButton.onPressed, isNull);
  });
}
