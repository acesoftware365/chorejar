# Google Play Console worksheet — ChoreJar 1.0.1 (11)

## App and review access

- Package: `com.liisgo.chorejar`
- App type: App
- Category: Parenting
- Price: Free
- Contains ads: **Yes** — one banner only in the confirmed-adult parent area.
- Review access: **No special access required.** A reviewer can create a parent
  account with any email address and password. The flow is in
  `REVIEWER_NOTES.md`.
- Account deletion URL:
  `https://chorejar-liisgo-2026.web.app/delete-account`
- Privacy policy URL:
  `https://chorejar-liisgo-2026.web.app/privacy`
- Terms of use URL:
  `https://chorejar-liisgo-2026.web.app/terms`

## Target audience and Families

Google Play requires the selected ages to be consecutive. Select **6–8**,
**9–12**, **13–15**, **16–17**, and **18 and over**. Do not select 5 and
under. The primary account holder is a parent or caregiver; a strictly
parent-controlled profile is also suitable for children and teens ages 6–17.

Accurate answers:

- The app includes advertising: **Yes**.
- Child users see advertising: **No**.
- A parent/caregiver confirms they are 18 or older before the adult area and
  its banner can open.
- The child route has no money-moving controls, account creation, public
  profiles, messaging, social sharing, web browsing, or external links.
- The production Android manifest removes the Android Advertising ID
  permission. The banner is non-personalized, G-rated, and uses Google Mobile
  Ads child age treatment.

Enroll or answer under the Families requirements only with the final bundle
that preserves these safeguards. The account holder must personally make the
Play Console certification that the app, its SDKs, and its ads comply with the
applicable child-privacy laws. Do not reuse the old Cash Rewards response.

## Content rating

Start a new IARC questionnaire from the 1.0.1 build. Answer **No** to cash
rewards, real-money gambling, financial transactions, payment transfers,
public user interaction, sharing personal information, and user-generated
content visible outside the private family. The app contains private task and
goal text entered by the parent, but no public feed, chat, marketplace, or
unmoderated sharing. Answer all remaining questions from the actual form; do
not copy the former cash-out answers.

## Data safety

Answer **Yes, this app collects data** and **Yes, data is encrypted in
transit**. Account deletion is available in the app and at the public deletion
URL. The following is the conservative disclosure inventory for the production
binary; check the final Play SDK report before saving:

| Play data type | Collected | Shared | Purpose | Linked | Required/optional |
| --- | --- | --- | --- | --- |
| Email address | Yes | No | Account management, app functionality | Yes | Required for a parent account |
| Name | Yes, parent-entered nickname | No | App functionality | Yes, within the private family | Optional |
| User IDs | Yes, Firebase user ID | No | Account management, app functionality | Yes | Required for authenticated use |
| Other financial info | Yes, parent-entered allowance and money records | No | App functionality | Yes, within the private family | Optional |
| Other user-generated content | Yes, tasks, instructions, goal names, notes | No | App functionality | Yes, within the private family | Optional |
| Approximate location | Yes, from IP by Google Mobile Ads | Yes, Google Mobile Ads | Advertising, analytics, fraud prevention | Per SDK policy | Automatic when the adult banner loads |
| App interactions | Yes, by Google Mobile Ads | Yes, Google Mobile Ads | Advertising, analytics, fraud prevention | Per SDK policy | Automatic when the adult banner loads |
| Crash logs / diagnostics | Yes, by Google Mobile Ads | Yes, Google Mobile Ads | Advertising, analytics, fraud prevention | Per SDK policy | Automatic when the adult banner loads |
| Device or other IDs | Yes, App Set ID and other SDK identifiers; Android AD_ID permission is removed | Yes, Google Mobile Ads | Advertising, analytics, fraud prevention | Per SDK policy | Automatic when the adult banner loads |

Firebase Authentication and Cloud Firestore provide the private family account
and sync. They do not receive data for advertising. The Google Mobile Ads SDK
may process the listed advertising/diagnostic data only after the adult parent
area initializes its banner. No family nickname, task, goal, balance, or money
record is given to advertising.

## Financial features

Select **No** for financial products, bank accounts, payments, transfers,
lending, investment, credit, cash rewards, wallet, or cash-out features.
ChoreJar is a family record keeper. A parent records events after they happen
outside the service; it does not move funds.
