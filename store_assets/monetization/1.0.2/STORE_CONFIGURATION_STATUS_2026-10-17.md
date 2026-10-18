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

## Google Play Console — base-plan creation blocked

Subscription product `chorejar_premium_monthly` exists as a draft with English
benefits and a parent-only description. Its plan was tested using both of these
configurations:

| Test | Base plan | Market availability | Price |
| --- | --- | --- | --- |
| Worldwide | Auto-renewing monthly; 7-day grace period; automatic account hold | 175 Play countries/regions | USD 0.99 with Play-calculated local prices |
| Minimal isolation | Auto-renewing monthly; 7-day grace period; automatic account hold | United States only | USD 0.99 |

On 2026-10-17, Google Play Console rejected **both** Save actions with only the
generic message `Your changes couldn't be saved`. This remained true after
reloading the product page and removing optional tags. The console supplied no
field-level error, so the failure is independent of worldwide availability,
regional pricing, and the optional tag. The base plan was discarded after each
failed attempt and remains unsaved and inactive. No annual Google product was
created, avoiding an incomplete storefront.

The Console's Monetization setup screen exposes no outstanding required field.
Alternative billing is not configured and is not required for ordinary Google
Play Billing. Real-time developer notifications remain off until the server-side
verifier and a Pub/Sub endpoint are ready.

On 2026-10-17, a Google Play support ticket was submitted under Monetization >
Managing monetization > subscriptions. It is `Pending` and its case ID is still
pending; Google says it will reply by email within two business days, though
some cases may take longer. The request includes the exact steps, failed
worldwide and U.S.-only tests, and asks whether the app's initial production
review status is the cause. Play Console's AI recommendation claimed that the
first base plan cannot be saved until the app is published or available on an
internal test track. This is an unverified explanation, not a confirmed policy
or a reason to alter the release currently in review.

## Remaining release gates

1. Resolve the Google Play Console base-plan save failure before creating the
   annual draft: `chorejar_premium_yearly`, base plan `yearly`, auto-renewing
   annually, all supported regions, and USD 9.99 reference price.
2. Implement, deploy, and test authenticated server-side Apple and Google
   receipt verification and entitlement updates.
3. Run sandbox/license-testing coverage for purchase, restore, renewal, expiry,
   refund, cancellation, account change, and offline recovery.
4. Ship a new signed build with the purchase feature enabled only after the
   verifier and both store products are ready; submit the new build and Apple
   subscription group together for review.
