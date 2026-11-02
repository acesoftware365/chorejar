# iPad keyboard rejection and fix — ChoreJar 1.0.2 (13)

Apple rejected 1.0.2 (12) on 2026-11-02 under Guideline 2.1(a). On an iPad Air
11-inch (M3) with iPadOS 27.2, the reviewer could not use the email/password
fields on the sign-in and sign-up screens because the keyboard did not remain
available.

The login layout classified portrait versus wide mode using the height of the
Scaffold body. Opening the keyboard shortened that body enough to switch an
iPad in portrait to the wide layout. The switch replaced the focused text
field, dismissed the keyboard, and returned the page to the portrait layout.
The compact wide layout also gave country/currency dropdown menu items a
46-point height, below Flutter's 48-point minimum.

The layout now classifies the device using the full MediaQuery viewport, which
does not shrink when the keyboard opens. Compact entry controls use at least
48 points. The email and password fields have stable keys for regression tests.

Validation before upload:

- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub`: passed, including focused-keyboard regression tests
  for iPad portrait and landscape, sign-in and account creation.
- The app launched on an iPad Air 11-inch (M3), iPadOS 27.2 simulator. A
  temporary device integration test tapped and entered text in both fields on
  the sign-in and account-creation screens; both passed. The test-only
  integration plugin was removed before the production build.
- `flutter clean`, `flutter pub get`, `flutter analyze --no-pub`, and
  `flutter test --no-pub` completed successfully before the production build.
- Signed IPA exported successfully. The embedded Runner app reports version
  1.0.2, build 13, bundle ID `com.liisgo.chorejar`, and non-exempt encryption
  set to false; `codesign --verify --deep --strict` passed. No app extension is
  present.
- Transporter delivered build 13 to App Store Connect on 2026-11-02. Apple
  showed the upload as **Processing**. Selection and resubmission remain to be
  recorded once processing finishes.

This change requires a new binary. Keep the visible version at 1.0.2 and use
build 13. Do not resubmit build 12.
