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
- The signed AAB is uploaded to the Google Play production release. Release
  notes in en-US and es-419 and full rollout after approval are saved. On
  October 16, 2026, the account holder authorized withdrawing the initial
  United States-only review, expanding the production target to all 177 listed
  countries or regions plus **Rest of World**, and resubmitting. Google's
  automated checks completed successfully and Google Play confirms that the
  changes are now **in review**. It is not yet published; the full rollout will
  begin automatically after Google approves it.
- The App Store Connect record is **ChoreJar: Family Chores** (Apple ID
  `6823823108`) and its iOS 1.0.1 page is in Prepare for Submission. The IPA
  1.0.1 (11) was delivered. English (U.S.) and Spanish (Mexico) metadata and
  five App Store compliant iPhone screenshots for each localization are saved.
- App Store Connect now has a free price schedule in all 175 supported
  countries or regions, and its availability is set to **Available on App
  Release** worldwide. This means the iOS app will be free globally after it
  clears App Review; it has not yet been submitted or published.

## Account-holder actions before review

1. **Apple App Review contact:** authorize submitting a review contact and the
   prepared review notes. The sign-in requirement should be turned off because
   a reviewer can create any parent account in the app.
2. **Apple content rights:** the account holder must confirm LIISGO LLC owns
   or is licensed to distribute the ChoreJar name, source code, jar artwork,
   screenshots and other marketing graphics before declaring Content Rights.
3. **Apple export compliance:** the IPA includes
   `openssl_grpc.framework` through Firebase/Firestore. Confirm the applicable
   export classification or required documentation; do not claim the IPA uses
   only Apple system encryption. Select build 11 only after its compliance
   state is resolved.
4. **Apple availability and price:** complete. The app is free in all 175
   supported countries or regions and will be available on release worldwide.
5. Publish App Privacy and submit the selected build only after the preceding
   items are confirmed. Recheck Data safety and App Privacy if the SDK
   inventory, advertising setup, account deletion behavior or final signed
   binary changes.
