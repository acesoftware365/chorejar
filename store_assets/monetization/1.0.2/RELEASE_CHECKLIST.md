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
- [ ] Deploy the updated Terms of Use, including subscription and cancellation
      language, before enabling checkout.
- [ ] Build with the two secure defines only after all prior checks pass.
- [ ] Submit the new binary and subscription products together for review.
