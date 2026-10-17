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

  testWidgets('default release does not expose a subscription checkout', (
    tester,
  ) async {
    final strings = await Strings.load('es');
    await tester.pumpWidget(
      MaterialApp(
        home: MembershipScreen(strings: strings, parentAuthorized: true),
      ),
    );

    expect(find.text(strings('membershipComingSoon')), findsOneWidget);
    expect(find.text(strings('chooseMonthlyPlan')), findsNothing);
    expect(find.text(strings('chooseYearlyPlan')), findsNothing);
    expect(find.text(strings('restorePurchases')), findsNothing);
    expect(find.text(r'$0.99'), findsNothing);
    expect(find.text(r'$9.99'), findsNothing);
  });
}
