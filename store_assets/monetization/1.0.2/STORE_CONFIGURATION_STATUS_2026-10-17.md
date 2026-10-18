# Subscription storefront configuration status — 2026-10-17

This record distinguishes completed store drafts from a purchasable release.
No subscription is active, submitted for review, or available for purchase.
The current 1.0.2 (12) app review remains unchanged.

## Apple App Store Connect — drafts complete

Subscription group: `ChoreJar Premium` (group ID `22489205`).

| Product ID | Apple product ID | Duration | US reference price | Status |
| --- | ---: | --- | ---: | --- |
| `chorejar_premium_monthly` | `6824104772` | 1 month | $0.99 | Prepare for Submission |
| `chorejar_premium_yearly` | `6824105660` | 1 year | $9.99 | Prepare for Submission |

Both plans are configured for all available countries and regions with future
country availability enabled. English (U.S.) and Spanish (Mexico)
localizations are present. Family Sharing is not enabled. The first subscription
group must be submitted with a future app version after the purchase-verification
release gates are complete.

## Google Play Console — draft blocked by console save failure

Subscription product `chorejar_premium_monthly` exists as a draft. Its planned
base plan is:

- Base plan ID: `monthly`
- Type: auto-renewing, monthly
- Grace period: 7 days; automatic account hold
- Availability: all 175 Play countries/regions
- Reference price: USD 0.99, with Play-calculated local prices
- Tag: `monthly`

On 2026-10-17, Google Play Console calculated and displayed all regional
prices, but rejected the Save action repeatedly with only the generic message
`Your changes couldn't be saved`. The console supplied no field-level error.
The base plan therefore remains unsaved and inactive. The annual product and
base plan have deliberately not been created until this console-level save
failure is resolved.

## Remaining release gates

1. Resolve the Google Play Console save failure and create the annual draft:
   `chorejar_premium_yearly`, base plan `yearly`, auto-renewing annually,
   all supported regions, and USD 9.99 reference price.
2. Implement, deploy, and test authenticated server-side Apple and Google
   receipt verification and entitlement updates.
3. Run sandbox/license-testing coverage for purchase, restore, renewal,
   expiry, refund, cancellation, account change, and offline recovery.
4. Ship a new signed build with the purchase feature enabled only after the
   verifier and both store products are ready; submit the new build and Apple
   subscription group together for review.
