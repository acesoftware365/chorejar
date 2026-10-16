# ChoreJar 1.0.1 (11) — submission status

Updated October 16, 2026. This is a handoff record, not a legal opinion or a
certification on behalf of the account holder.

## Product represented to the stores

ChoreJar is a parent-controlled family organizer for chores, allowance records
and savings goals. It records events a parent has already handled in the real
world. It never holds, processes, transfers or pays funds, and a child cannot
initiate a payment, payout, cash-out, spending action or financial product.

The linked child profile has no advertising, email/password requirement,
public profile, messaging, external links or money-moving controls. A single
non-personalized, family-safe banner may appear only after a parent confirms
they are an adult and opens the parent area.

## Completed preparation

- Version/build: Android `1.0.1` / versionCode `11`; iOS `1.0.1` / build `11`.
- Android artifact: `build/app/outputs/bundle/release/app-release.aab`.
- iOS artifact: `build/ios/ipa/chorejar.ipa`; checked as Runner only, so there
  are no extensions or App Clips with a different version.
- Validation: clean dependency restore, analysis with no issues, 46 Flutter
  tests, and 58 Firebase smoke checks with their synthetic data removed.
- Public pages: `/privacy`, `/terms`, `/support` and `/delete-account` are
  deployed from `hosting/`.
- Google Play draft listing is saved in English (United States) and Spanish
  (Latin America), each with an icon, feature graphic and five clean iPhone 17
  Pro Max screenshots. The Play review screen presents its AI-asset declaration
  for the account holder to answer truthfully and to label individual assets if
  the selected answer requires it.
- IARC was updated for the 1.0.1 scope: no cash rewards, payment transfers or
  financial products. The resulting rating is suitable for the selected mixed
  age groups.

## Account-holder actions before review

1. **Google Play Console:** personally review and complete the Families,
   target-audience and Data safety declarations for the final binary. Play
   requires the account holder to certify compliance with applicable
   child-privacy laws for the app, SDKs and advertisements. The selected
   consecutive groups are 6–8, 9–12, 13–15, 16–17 and 18+, never 5 and under.
2. **Google Play Console:** upload the listed AAB to the production release,
   complete its release notes, review automated checks, and send the saved
   changes for review only after the preceding certification is true.
3. **Apple Developer:** the Legal Account Holder must accept the current Apple
   Developer Program License Agreement and Paid Applications Schedule. Those
   agreements cannot be accepted by a delegate.
4. **App Store Connect:** create or grant access to the record for
   `com.liisgo.chorejar`, then upload the IPA, select build 11, apply the
   English/Spanish metadata and App Privacy answers, and submit for App Review.
5. Recheck Data safety and App Privacy if the SDK inventory, advertising setup,
   account deletion behavior or final signed binary changes.
