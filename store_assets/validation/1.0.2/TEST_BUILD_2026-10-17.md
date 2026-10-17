# ChoreJar 1.0.2 (12) — test-build validation

**Purpose:** Android test APK for hands-on review before any new store upload.
This is not a store artifact and must never be submitted to Google Play or the
App Store.

## Result

| Check | Result |
| --- | --- |
| Clean dependency resolution | Passed |
| Static analysis | Passed with no issues |
| Automated Flutter suite | 51 tests passed |
| Firebase rules / cloud smoke test | 58 checks passed; synthetic accounts and documents cleaned up |
| Android debug APK | Built successfully |
| Android emulator launch | Opened `com.liisgo.chorejar/.MainActivity` successfully; no app crash in startup log |
| Version verified in APK | `1.0.2 (12)` |
| Android compatibility | min SDK 24; target SDK 36; arm64-v8a, armeabi-v7a and x86_64 included |
| Debug advertising configuration | Verified Google’s Android test AdMob application ID in the final APK manifest |
| Premium checkout | Disabled by default; no payment can start |

## Delivered file

A debug-signed test copy was placed outside the repository for manual Android
installation:

`~/Desktop/ChoreJar - APK de Prueba 1.0.2 (12)/ChoreJar-1.0.2-12-prueba.apk`

SHA-256:

```text
ee4ff4ea6532616ade3d7f7087019404aaba895f81ef93491ff5f6f7ff1fc926
```

This APK intentionally uses Android Debug signing. If an Android device has a
copy signed differently, it cannot update that copy in place. The tester should
use a test device or remove the earlier test copy first.

## Manual acceptance to complete

- [ ] Parent can sign in or create a new account on the target physical phone.
- [ ] Parent can create a profile, chore, reward, manual money entry and goal.
- [ ] Child QR/link/code pairs a separate device and cannot see parent settings,
      advertisements, plan or purchase controls.
- [ ] Parent banner clearly identifies Google test inventory.
- [ ] Amount fields clear on entry, show a numeric keyboard and dismiss it with
      Done/Enter.
- [ ] English and Spanish layouts look correct on the target device.
- [ ] Parent confirms the visual design and all main flows before any new store
      build is produced.
