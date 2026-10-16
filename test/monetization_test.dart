import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/screens/membership.dart';
import 'package:chorejar/services/advertising.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unavailable ads cannot grant a reward or enable premium', () async {
    final ads = Advertising();
    expect(await ads.watchForQuietDay(), isFalse);
    expect(ads.quiet, isFalse);
    expect(ads.showBanner, isFalse);
    expect(ads.rewardBusy, isFalse);
    ads.dispose();
  });
  test('a rewarded quiet period does not suppress the fixed parent banner', () {
    final ads = Advertising()..ready = true;
    ads.quietUntil = DateTime.now().subtract(const Duration(seconds: 1));
    expect(ads.showBanner, isTrue);
    ads.quietUntil = DateTime.now().add(const Duration(hours: 24));
    expect(ads.showBanner, isTrue);
    ads.dispose();
  });
  testWidgets(
    'unconfigured plans disclose no charge and disable unavailable reward',
    (tester) async {
      final strings = await Strings.load('es');
      await tester.pumpWidget(
        MaterialApp(home: MembershipScreen(strings: strings)),
      );
      expect(find.text('0.99 USD'), findsOneWidget);
      expect(find.text('9.99 USD'), findsOneWidget);
      expect(find.text(strings('plansPending')), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byWidgetPredicate((w) => w is FilledButton),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.byWidgetPredicate((widget) => widget is FilledButton),
            )
            .onPressed,
        isNull,
      );
    },
  );
}
