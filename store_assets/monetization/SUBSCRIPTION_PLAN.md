# Future subscription plan

This is a product plan for the next post-1.0.1 release. It is not enabled in
ChoreJar 1.0.1, is not listed to customers, and is not configured as a
purchasable product in App Store Connect or Google Play Console.

The 1.0.2 (12) source now contains a disabled purchase client, restore flow,
Premium banner suppression, bilingual plan UI, and an HTTPS verifier contract.
It does not enable checkout or grant an entitlement until the server and both
store products complete the release gates.

| Product | Reference price (USD) | Cadence | Proposed identifier |
| --- | ---: | --- | --- |
| ChoreJar monthly | $0.99 | Monthly | `chorejar_premium_monthly` |
| ChoreJar yearly | $9.99 | Yearly | `chorejar_premium_yearly` |

Storefront prices, taxes, currency conversions, introductory offers and
eligibility must be set by the account holder in each store when the products
are created. The price references above do not create a charge or an offer.

## Required before activation

1. Keep the paid benefit truthful: Premium removes the adult parent-area
   banner; it does not alter child access, family records or money decisions.
2. Implement and deploy the authenticated server verifier described in
   `1.0.2/VERIFICATION_PROTOCOL.md`; never trust an on-device receipt.
3. Test sandbox purchase, restore, renewal, expiry, refund and account changes
   on iOS and Android.
4. Deploy the prepared subscription terms and update final privacy/data safety
   disclosures to match the deployed verifier.
5. Create the products, localized names/descriptions and review screenshots in
   both stores only after the verifier and release build are ready.
6. Submit a new build and both products for store review. Never activate a
   product for a build that says paid plans are unavailable.
