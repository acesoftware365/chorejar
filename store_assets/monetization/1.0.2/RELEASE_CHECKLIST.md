# ChoreJar Premium release checklist

This checklist belongs to the next post-1.0.1 release. Current store review
version 1.0.1 (11) stays free and must not expose a paid offer.

- [ ] Implement and deploy the authenticated server verifier described in
      `VERIFICATION_PROTOCOL.md`.
- [ ] Obtain Apple App Store Server API credentials and Google Play Developer
      API access for the verifier; keep secrets outside this repository.
- [ ] Create the two subscription products with the identifiers and localized
      copy in `STORE_PRODUCT_COPY.md`.
- [ ] Configure USD reference prices: $0.99 monthly and $9.99 yearly; review
      each storefront's local price, tax and currency display.
- [ ] Test new purchase, restore, renewal, cancellation, refund, expiration,
      family-account change and offline recovery in Apple sandbox and Google
      Play license testing.
- [ ] Update App Store App Privacy and Google Play Data safety to the final
      server-side data flow.
- [x] Deploy the updated Terms of Use and Privacy Policy with parent-only
      subscription, cancellation and child-data language. Published 2026-10-17.
- [ ] Build with the two secure defines only after all prior checks pass.
- [ ] Submit the new binary and subscription products together for review.

## Completed client preparation

- [x] Present monthly ($0.99 USD reference) and yearly ($9.99 USD reference)
      plans in the authenticated parent area only.
- [x] Keep the child area ad-free and omit subscription controls from child
      sessions; the screen also blocks direct access without parent authorization.
- [x] Include clear restoration, automatic-renewal, cancellation, price/tax,
      privacy and terms disclosures in English and Spanish.
- [x] Validate the parent-only guard and disabled-by-default checkout in the
      automated test suite.

These completed items do not enable purchases. The unchecked server, store and
sandbox requirements above remain mandatory before any paid release.
