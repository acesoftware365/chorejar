# App Review Notes template — ChoreJar 1.0.2 (12)

Use this immediately before submitting the finished 1.0.2 build. Replace every
bracketed placeholder in App Store Connect; do not store production credentials,
pairing tokens or sandbox secrets in the repository.

## Notes for App Review

ChoreJar is a private, parent-led organizer for chores, manually recorded
allowance entries and savings goals. It is a record keeper only: it does not
hold, transfer, withdraw or pay money.

### Parent flow

1. From the welcome screen, select **I’m a parent** / **Soy mamá o papá**.
2. Create a parent account with the reviewer’s email, or use this current
   review account: `[review account supplied at submission]`.
3. Confirm the adult-parent prompt, add a child profile, then add a chore,
   an allowance record or a savings goal.
4. Open **Settings → Plan and ads** to verify the parent-only ad-reporting
   route. The free banner, if returned by the ad service, appears only in this
   adult area.

### Child companion flow

A child does not create an account or provide an email/password. In the parent
area, open the child profile and choose **Preview child view**, or use **Link
device** to create a one-time QR/link/code. The linked child view shows only
that profile’s tasks, balances/categories and savings goal. It never displays
advertising, subscriptions, money-moving actions or a payout request.

### Private content and safety

There is no public user profile, public feed, social sharing, anonymous chat,
marketplace or communication between families. All family records stay inside
the authenticated, parent-controlled private family. Parents can unlink a
device, archive a profile or delete the parent account and family data in
Settings.

### Premium (include only after the products are approved for review)

Premium is available only after the authenticated adult-parent gate. It removes
the banner from the adult parent area; it does not change the child experience.
The purchase screen shows the storefront price, billing period, automatic
renewal/cancellation information, privacy/terms links and **Restore purchases**.

Subscription products submitted with this version:

- Monthly: `chorejar_premium_monthly`
- Yearly: `chorejar_premium_yearly`

Use the standard App Review sandbox purchase flow. The entitlement is checked
securely for the signed-in adult family account. Child accounts and child-linked
devices cannot see, purchase or restore Premium.

### Contacts

- Privacy policy: `https://chorejar-liisgo-2026.web.app/privacy`
- Terms of use: `https://chorejar-liisgo-2026.web.app/terms`
- Support: `https://chorejar-liisgo-2026.web.app/support`
- Review contact: `[name, email and telephone entered in App Store Connect]`
