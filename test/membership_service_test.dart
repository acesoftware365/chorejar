import 'package:chorejar/services/membership.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Premium catalog uses stable store identifiers and reference prices',
    () {
      expect(PremiumPlan.values, hasLength(2));
      expect(PremiumPlan.monthly.id, 'chorejar_premium_monthly');
      expect(PremiumPlan.monthly.cadence, 'monthly');
      expect(PremiumPlan.monthly.referencePrice, r'$0.99 USD');
      expect(PremiumPlan.yearly.id, 'chorejar_premium_yearly');
      expect(PremiumPlan.yearly.cadence, 'yearly');
      expect(PremiumPlan.yearly.referencePrice, r'$9.99 USD');
      expect(
        PremiumPlan.ids,
        containsAll(<String>[PremiumPlan.monthly.id, PremiumPlan.yearly.id]),
      );
    },
  );

  test('default builds cannot start a subscription checkout', () {
    expect(MembershipConfiguration.enabled, isFalse);
    expect(MembershipConfiguration.checkoutConfigured, isFalse);
  });

  test('only a verified active entitlement is Premium', () {
    const active = MembershipEntitlement(
      active: true,
      productId: 'chorejar_premium_yearly',
    );
    const inactive = MembershipEntitlement(active: false);
    expect(active.active, isTrue);
    expect(inactive.active, isFalse);
  });

  test('server entitlement parsing does not grant access by default', () {
    final parsed = MembershipEntitlement.fromJson(<String, dynamic>{
      'productId': 'chorejar_premium_monthly',
    });
    expect(parsed.active, isFalse);
    expect(parsed.productId, 'chorejar_premium_monthly');
  });
}
