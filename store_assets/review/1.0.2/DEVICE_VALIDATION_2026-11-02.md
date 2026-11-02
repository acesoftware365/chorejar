# Keyboard and layout validation — iOS 1.0.2 (13)

Apple reported that email and password fields did not prompt a usable keyboard
on an iPad Air 11-inch (M3), iPadOS 27.2. The source used for build 13 was
checked again on these iOS 27.2 simulators:

| Simulator | Automated sign-in fields | Automated sign-up fields | Manual app check |
| --- | --- | --- | --- |
| iPad Air 11-inch (M3) | Pass | Pass | Email and password keyboards appeared; landscape sign-up remained scrollable. |
| iPad mini (A17 Pro) | Pass | Pass | Sign-in and sign-up keyboards appeared with fields and action button accessible. |
| iPad Pro 13-inch (M5) | Pass | Pass | Sign-in and sign-up keyboards appeared; no field was obscured in portrait. |
| iPhone 17e | Pass | Pass | Both keyboards appeared; Next moved focus from email to password. |

The temporary on-device integration test tapped both fields, verified focus,
entered dummy text, and checked the resulting field values in sign-in and
sign-up mode on each simulator: 8 cases passed. The test-only dependency and
test file were removed before the normal app launches. The permanent widget
regression test also covers iPad portrait and landscape with a simulated
keyboard inset. `flutter analyze --no-pub` found no issues and all 55 project
tests passed with `flutter test --no-pub`.

Manual checks used the normal app, including the parent age gate. On iPads,
Device Hub initially had **Simulate Hardware Keyboard** enabled, which hid the
on-screen keyboard even when the email field had focus. After turning that
simulator option off, the software keyboard appeared and stayed open. This
simulator setting was separate from the app layout defect fixed in build 13.
The iPad Air password field accepted a tap on the software keyboard. In
landscape, the sign-up form scrolled to expose its action button above the
keyboard.

One minor display issue remains: on the iPad Air in landscape while the
keyboard is open, the compact Country control shortens "United States" to
"United". The country menu still shows full names. This did not block text
entry or sign-in and was not changed in the build already awaiting review.

Evidence screenshots from the normal app:

- [iPad Air M3 landscape](device_validation/ipad-air-m3-landscape-keyboard.png)
- [iPad mini A17 portrait](device_validation/ipad-mini-a17-create-keyboard.png)
- [iPad Pro 13 M5 portrait](device_validation/ipad-pro-13-m5-create-keyboard.png)
- [iPhone 17e portrait](device_validation/iphone-17e-create-keyboard.png)

These are simulator checks of a debug build from the same source as 1.0.2
(13). They do not replace a physical-device test or a fresh Apple review, and
this pass did not repeat an authenticated sign-in against Firebase.
