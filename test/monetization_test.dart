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
  testWidgets('unconfigured plans disclose that paid plans are unavailable', (
    tester,
  ) async {
    final strings = await Strings.load('es');
    await tester.pumpWidget(
      MaterialApp(home: MembershipScreen(strings: strings)),
    );
    expect(find.text(strings('premiumPlan')), findsOneWidget);
    expect(find.text(strings('monthlyPlanPrice')), findsOneWidget);
    expect(find.text(strings('yearlyPlanPrice')), findsOneWidget);
    final monthlyButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, strings('chooseMonthlyPlan')),
    );
    expect(monthlyButton.onPressed, isNull);
  });
}
