import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/screens/membership.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Premium controls are blocked without parent authorization', (
    tester,
  ) async {
    final strings = Strings(<String, dynamic>{
      'membership': 'Plan and ads',
      'premiumParentOnlyTitle': 'Premium is for parents',
      'premiumParentOnlyBody': 'Only a signed-in adult can manage this plan.',
    });

    await tester.pumpWidget(
      MaterialApp(
        home: MembershipScreen(strings: strings, parentAuthorized: false),
      ),
    );

    expect(find.text('Premium is for parents'), findsOneWidget);
    expect(
      find.text('Only a signed-in adult can manage this plan.'),
      findsOneWidget,
    );
    expect(find.text('Choose monthly'), findsNothing);
    expect(find.text('Choose yearly'), findsNothing);
  });
}
