# App Store Connect worksheet — ChoreJar 1.0.1 (11)

## App record and availability

- Bundle ID: `com.liisgo.chorejar`
- Version: `1.0.1`
- Build: `11`
- Primary category: **Lifestyle** (Apple lists parenting as a Lifestyle
  example). Secondary category: leave empty unless the final App Store Connect
  options show a more accurate category.
- Distribution: automatic release after approval.
- Made for Kids: **No.** The primary intended user is a parent or caregiver.
  Parent-controlled child profiles are a limited companion experience, not a
  child account or a public social service. Do not use “For Kids” or “For
  Children” in the name, subtitle, keywords, screenshots, or description.
- App review contact and the account holder's legal agreements must be current
  before submission.

## Age rating questionnaire

Answer the current App Store Connect questions from the actual binary:

- Advertising: **Yes**, a non-personalized banner in the confirmed-adult
  parent area only.
- Parental controls: **Yes**, the parent owns profiles, invitations, device
  linking, money records, and account deletion.
- Messaging, chat, social networking, public user-generated content, web
  browsing, gambling, real-money transactions, alcohol, drugs, sexual content,
  violence, and unrestricted web access: **No**.
- Do not enter a manual age rating; let App Store Connect calculate it from
  those accurate responses.

## App Privacy

Answer **Yes, this app collects data** and include both app code and third
party SDKs. The App Privacy form applies across all platforms, so use this
conservative inventory and compare it with Xcode's final privacy report:

| Apple data type | Source | Purpose | Linked to identity | Used for tracking |
| --- | --- | --- | --- | --- |
| Contact Info → Email Address | Parent account | App functionality, account management | Yes | No |
| Identifiers → User ID | Firebase Authentication | App functionality, account management | Yes | No |
| User Content → Other User Content | Family-entered nicknames, chores, instructions, goals, notes | App functionality | Yes, private family account | No |
| Financial Info → Other Financial Information | Parent-entered allowance and money records | App functionality | Yes, private family account | No |
| Location → Coarse Location | Google Mobile Ads IP-based estimate | Third-party advertising, analytics, fraud prevention | Per SDK practice | No, with child age treatment |
| Identifiers → Device ID | Google Mobile Ads SDK | Third-party advertising, analytics, fraud prevention | Per SDK practice | No, with child age treatment |
| Usage Data → Product Interaction | Google Mobile Ads SDK | Third-party advertising, analytics, fraud prevention | Per SDK practice | No, with child age treatment |
| Diagnostics → Crash Data / Performance Data | Google Mobile Ads SDK | Third-party advertising, analytics, fraud prevention | Per SDK practice | No, with child age treatment |

Do not claim that App Tracking Transparency is requested or that data is used
for tracking. This release uses child age treatment, non-personalized ad
requests, disables the iOS same-app key, and does not include an ATT prompt.
If the final privacy report or Google Mobile Ads account configuration changes
that fact, stop and revise the form and code before submission.

Use:

- Privacy policy: `https://chorejar-liisgo-2026.web.app/privacy`
- Terms of use: `https://chorejar-liisgo-2026.web.app/terms`
- User privacy choices / account deletion:
  `https://chorejar-liisgo-2026.web.app/delete-account`

## App Review information

Paste the contents of `REVIEWER_NOTES.md` into the App Review Notes field. No
demo account, child email, payment method, hardware, or external device is
required. A reviewer can make a parent account in the app.

## Export compliance and rights

Complete Apple’s export-compliance questionnaire from the final IPA and the
account holder’s business facts. Do not guess an encryption answer. Confirm
that the account holder has the right to submit the ChoreJar name, jar artwork,
source code, and marketing graphics before pressing Submit for Review.
