# Future subscription plan

This is a product plan for a future release. It is not enabled in ChoreJar
1.0.1, is not listed to customers, and is not configured as a purchasable
product in App Store Connect or Google Play Console.

| Product | Reference price (USD) | Cadence | Proposed identifier |
| --- | ---: | --- | --- |
| ChoreJar monthly | $0.99 | Monthly | `chorejar_premium_monthly` |
| ChoreJar yearly | $9.99 | Yearly | `chorejar_premium_yearly` |

Storefront prices, taxes, currency conversions, introductory offers and
eligibility must be set by the account holder in each store when the products
are created. The price references above do not create a charge or an offer.

## Required before activation

1. Define the paid benefits and keep the free-version behavior truthful.
2. Implement StoreKit and Google Play Billing purchase, entitlement, restore
   purchases, cancellation and error flows in the app.
3. Test sandbox purchase, restore and account changes on iOS and Android.
4. Add subscription terms, renewal/cancellation language and support contact
   to the privacy/terms pages and localized store listings.
5. Create the products, localized names/descriptions and review screenshots in
   both stores only after the release build implements the flows.
6. Submit a new build for store review. Never activate a product for a build
   that says paid plans are unavailable.
