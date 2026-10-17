# Store materials

These files are the source copy for the public ChoreJar release candidate. The
visible version is `1.0.1` and the Android and iOS build number is `11`.

- Google Play uses `google_play/1.0.1/listing/en-US.txt` and the matching
  release notes file.
- App Store Connect uses `app_store/1.0.1/release-notes.md` and the matching
  localized metadata under `app_store/1.0.1/`.
- Privacy policy: `https://chorejar-liisgo-2026.web.app/privacy`
- Support: `https://chorejar-liisgo-2026.web.app/support`
- English and Spanish metadata, localized promotional graphics, screenshot
  guides, and the future localization queue live under this folder. Only
  English and Spanish are enabled in the app for this release.

`RELEASE_1.0.1_PRODUCT_SCOPE.md` is the source of truth for the product
boundary, child controls, review explanation, and advertising boundary. The
previous pre-child-safe listing copy is retained under `archive/` only for
history and must never be submitted.

The exact store-form answers and reviewer walkthrough are in
`review/1.0.1/`. Use these with the final signed AAB/IPA privacy reports;
the public privacy page and the store declarations must stay consistent.

Do not declare subscriptions or an ad-free plan in either store until the
purchase flow and store products are implemented and reviewed.

The approved commercial target for that future work is recorded in
`monetization/SUBSCRIPTION_PLAN.md`: $0.99 USD monthly and $9.99 USD yearly.
It remains intentionally disabled for 1.0.1.
