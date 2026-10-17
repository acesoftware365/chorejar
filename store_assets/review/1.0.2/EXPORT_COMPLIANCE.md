# Apple export-compliance declaration — ChoreJar 1.0.2 (12)

## Decision recorded in the iOS app

`ios/Runner/Info.plist` contains:

```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

ChoreJar does not implement proprietary cryptographic algorithms, direct
cryptographic storage, custom key management, a VPN, a secure-messaging
protocol, or client-side file/database encryption. The app uses the operating
system and Firebase/Google SDK transport security for authenticated HTTPS/TLS
communication; it does not expose a custom cryptography feature to families.

Apple documents that `ITSAppUsesNonExemptEncryption` set to `NO` declares that
the app and linked libraries either use no encryption or only encryption that
is exempt from export-compliance documentation. This declaration must be
reassessed before a future release that adds non-exempt encryption, custom key
management, encrypted files/databases, a VPN, or a cryptography product.

## App Store Connect answer for the shown question

For this source, select **“None of the algorithms mentioned above.”** The app
does not itself implement proprietary encryption or standard encryption beyond
system/service transport security. The selection is backed by the `false`
Info.plist value in the next uploaded build.

## Important scope

This does not alter an IPA that Apple has already processed. App Store Connect
will read the declaration when the next iOS build is uploaded. If App Store
Connect still asks for export-compliance information for an already-uploaded
build, complete its prompt for that build; do not change the answer to conceal
a future cryptography feature.

## Sources

- Apple: [ITSAppUsesNonExemptEncryption](https://developer.apple.com/documentation/bundleresources/information-property-list/itsappusesnonexemptencryption)
- Apple: [Complying with Encryption Export Regulations](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations)
