# Premium entitlement verification protocol

**Status:** implementation contract for the next release. No verifier endpoint
is configured in the app and checkout is disabled by default.

## Client safeguards

- The Flutter client uses the official `in_app_purchase` package.
- It subscribes to purchase updates at app launch, obtains store product details
  by the two fixed product IDs, and sends a transaction only to an HTTPS
  verifier endpoint supplied at build time.
- The client sends the Firebase parent ID token in the Authorization header and
  the store's `serverVerificationData` in the JSON body. It does not write a
  receipt or Premium flag to preferences or Firestore.
- Premium is granted only when the verifier returns `{ "active": true }` for
  the signed-in parent account. A linked child device never initializes this
  flow.
- A transaction is completed only after the verifier responds. A verification
  network failure leaves the store transaction pending for a later retry.

## Required verifier endpoints

The HTTPS endpoint supplied in `SUBSCRIPTION_VERIFY_URL` must accept a JSON
POST with `action: "status"` or `action: "verify"`. It must authenticate the
Firebase ID token, validate the transaction with the correct store, associate
it with the authenticated parent account, and return only:

```json
{
  "active": true,
  "productId": "chorejar_premium_yearly",
  "expiresAt": "2027-10-16T00:00:00Z"
}
```

The service must reject an expired, refunded, revoked, duplicated, mismatched,
or wrong-app transaction. It must keep authoritative subscription state on the
server, process Apple/Google renewal and revocation notifications, and never
accept a product ID outside the two documented IDs.

## Build gates

Do not set `SUBSCRIPTIONS_ENABLED=true` unless all conditions are met:

1. The endpoint is HTTPS and production-ready.
2. Apple StoreKit and Google Play server verification credentials are stored as
   server secrets, never in Flutter or the repository.
3. The endpoint has passed sandbox purchase, cancellation, expiry, restore,
   account-change and duplicate-transaction tests.
4. Both storefront products are in their correct review state and their prices,
   localized copy, renewal terms, support link and screenshots are complete.
5. App Privacy and Data safety disclosures have been updated for purchase and
   diagnostic data actually processed by the verifier.

Example production build inputs, supplied only by secure CI after those gates:

```text
--dart-define=SUBSCRIPTIONS_ENABLED=true
--dart-define=SUBSCRIPTION_VERIFY_URL=https://<owned-domain>/membership
```
