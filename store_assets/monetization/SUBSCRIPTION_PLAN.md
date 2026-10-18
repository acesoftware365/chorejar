# Future subscription plan

This is the product plan for a future post-1.0.2 release. Checkout remains
disabled in ChoreJar 1.0.2. The app does not grant a paid entitlement until the
server verifier, store configuration, and release testing have completed.

Draft product configuration exists in App Store Connect for both plans. In
Google Play Console, the monthly subscription metadata exists as a draft, but
Google currently rejects creation of its base plan with a generic save failure.
There are no active, purchasable subscriptions in either store.

The 1.0.2 (12) source contains a disabled purchase client, restore flow,
Premium banner suppression, bilingual plan UI, and an HTTPS verifier contract.

| Product | Reference price (USD) | Cadence | Identifier |
| --- | ---: | --- | --- |
| ChoreJar monthly | $0.99 | Monthly | `chorejar_premium_monthly` |
| ChoreJar yearly | $9.99 | Yearly | `chorejar_premium_yearly` |

Premium is a parent-only benefit: it removes banner ads from the parent area.
Child profiles are always ad-free and never show purchases or subscription
prompts. Storefront prices, taxes, currency conversions, introductory offers,
and eligibility are controlled by the stores when products are activated. The
reference prices above do not create a charge or an offer.

## Required before activation

1. Resolve the Google Play Console save failure and finish the matching annual
   plan without activating either product.
2. Keep the paid benefit truthful: Premium removes the adult parent-area
   banner; it does not alter child access, family records or money decisions.
3. Implement and deploy the authenticated server verifier described in
   `1.0.2/VERIFICATION_PROTOCOL.md`; never trust an on-device receipt.
4. Test sandbox purchase, restore, renewal, expiry, refund and account changes
   on iOS and Android.
5. Deploy the prepared subscription terms and update final privacy/data safety
   disclosures to match the deployed verifier.
6. Create the remaining store localizations and review materials only after the
   verifier and release build are ready.
7. Submit a new build and both products for store review. Never activate a
   product for a build that says paid plans are unavailable.
