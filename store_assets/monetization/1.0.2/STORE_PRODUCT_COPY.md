# ChoreJar Premium — store product copy

**Status:** prepared for the next build only. Do not create or activate these
products until the server verifier, sandbox testing and the release build are
complete. This document does not authorize a charge.

## Shared customer benefit

ChoreJar Premium removes the family-safe banner from the confirmed adult parent
area. It does not change chores, family records, child access, money records,
parent controls, account deletion, or real-world money decisions. The child
area remains ad-free in every plan.

## Identifiers and USD reference prices

| Product ID | Billing period | Reference price |
| --- | --- | ---: |
| `chorejar_premium_monthly` | 1 month, auto-renewing | $0.99 USD |
| `chorejar_premium_yearly` | 1 year, auto-renewing | $9.99 USD |

Use the same product identifiers in App Store Connect and Google Play. Do not
reuse an identifier for a different benefit. Storefront prices, tax and local
currency are set by each store and are the customer-facing authority.

## App Store Connect

Create both products in a single auto-renewable subscription group named
**ChoreJar Premium**. Add each product to the next app version only after the
backend can validate StoreKit transactions.

| Locale | Monthly display name | Yearly display name | Description |
| --- | --- | --- | --- |
| en-US | ChoreJar Premium Monthly | ChoreJar Premium Yearly | Removes banner ads from the adult parent area. The child area is always ad-free. |
| es-MX | Mi Mesadita Premium mensual | Mi Mesadita Premium anual | Elimina los anuncios de banner del área adulta de padres. El área infantil siempre está libre de anuncios. |

## Google Play

Create one subscription product for each ID. Configure one base plan on each:
`monthly` for the monthly product and `yearly` for the yearly product. Keep
both offers without a trial or introductory discount until the first sandbox
release has been verified.

| Locale | Monthly title | Yearly title | Description |
| --- | --- | --- | --- |
| en-US | ChoreJar Premium Monthly | ChoreJar Premium Yearly | Removes banner ads from the adult parent area. The child area is always ad-free. |
| es-419 | Mi Mesadita Premium mensual | Mi Mesadita Premium anual | Elimina los anuncios de banner del área adulta de padres. El área infantil siempre está libre de anuncios. |
