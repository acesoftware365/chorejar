# App Review guideline audit — ChoreJar 1.0.2 (12)

**Date:** 2026-10-17  
**Scope:** the planned post-1.0.1 build, its App Store metadata, its public
privacy and terms pages, the parent-only advertising flow, and the planned
Premium subscription. This is an operational release-readiness audit, not legal
advice and not a promise of store approval.

## Decision

**Do not submit version 1.0.2 (12) with Premium merely displayed but disabled.**
The source intentionally defaults `SUBSCRIPTIONS_ENABLED` to `false` until it
has a secure verifier and complete store configuration. That is correct for
development, but it must not become a dormant paid feature in an App Review
build. Before submission, either:

1. finish the complete Premium flow below and submit the app and subscription
   products together; or
2. remove every Premium offer, price, purchase and restore route from the
   shipping binary and metadata.

The intended release is option 1. The currently reviewed 1.0.1 (11) release
remains a free parent-led organizer with a parent-only banner.

## Product boundary that must remain true

- ChoreJar is a private, parent-led family organizer for chores, manually
  recorded allowance entries and savings goals. It does not transfer, hold,
  send, withdraw or pay money.
- A parent or guardian creates and controls a family. Child profiles do not
  create accounts, provide credentials, see advertisements, buy subscriptions
  or restore purchases.
- There is no public profile, public feed, anonymous chat, messaging between
  families, marketplace, public child discovery or social sharing.
- The free banner is limited to a confirmed adult parent area. It is configured
  as non-personalized and age-restricted. A parent can report an inappropriate
  ad from **Plan and ads → Report an ad**.

## Guideline-by-guideline review

| Area | Current result | Required release action |
| --- | --- | --- |
| **1.2 — User-generated content** | ChoreJar is not a public UGC or social service. Family records are visible only inside a parent-controlled private family. | Keep public discovery, chat and cross-family sharing out of the app. Explain the private, adult-controlled model in App Review Notes. If any public sharing or community feature is added later, implement Apple’s required filtering, reporting, blocking and published contact safeguards before release. |
| **1.3 — Kids Category** | The child view is a limited companion experience, while the product also has adult ads and adult-only subscriptions. | Keep **Made for Kids / Kids Category** set to **No**. The primary user is a parent or caregiver. Reassess the product and its advertising design from scratch if this setting ever changes. |
| **2.3.1 and 2.5.19 — accurate, visible functionality** | Parent and child features are visible through the intended flows. Premium is deliberately disabled while its server and stores are unfinished. | This is a release blocker for Premium: no hidden, dormant or undocumented purchase path may remain in the signed build. Provide complete reviewer instructions and disclose every non-obvious pairing, ad and subscription feature. |
| **2.3.2 and 3.1.1 / 3.1.2 — subscriptions** | The client uses native in-app purchase preparation and limits plans to authorized parents. The actual products, secure entitlement verification and sandbox evidence are not complete. | Create the monthly and annual Apple/Google products, show each storefront-provided price and term before purchase, verify server-side, support Restore purchases, and submit products with the binary. Do not add an external purchase link. |
| **2.3.3 — screenshots** | The existing product screenshots show actual parent and child flows. | Keep five or more truthful screenshots per required device family. Do not use mockups that depict features the build does not provide. |
| **2.3.14 — creative assets** | Ready for upload. The Header and Search Results artwork depicts ChoreJar’s jar, task/goal concept and brand. It has no price, discount, external website, competing platform, personal data or unsupported performance claim. | Upload the final localized files listed below, inspect each App Store Connect preview, and keep the version of each file that matches its locale. |
| **2.5.18 — advertising** | The banner is initialized and displayed only in the adult parent area; child routes omit it. The parent has a reporting path. | Retest the final signed build: parent view may show the banner; child preview and linked child session must never show it. Recheck the final SDK privacy report and age-rating answers. |
| **5.1.1 — privacy** | Public Privacy Policy, Terms, Support and account-deletion pages are live. They describe parent login data, private family records, Firebase sync, adult-only non-personalized ads and the proposed Premium verification data flow. | Before Premium submission, update App Store App Privacy and Google Play Data safety to match the final verifier, SDK reports and retention behavior. Keep the live policy linked in store metadata and in the app. |

## App Store discovery artwork prepared for 1.0.2

The final exports are flattened RGB PNGs with no transparency and contain no
pricing or promotion claims.

| Surface | Locale | File | Size |
| --- | --- | --- | --- |
| Header | English (U.S.) | `store_assets/marketing/1.0.2/app_store/creative_assets/header-en-US-3840x1646.png` | 3840 × 1646 (21:9) |
| Header | Spanish (Latin America) | `store_assets/marketing/1.0.2/app_store/creative_assets/header-es-419-3840x1646.png` | 3840 × 1646 (21:9) |
| Header | Spanish (Spain) | `store_assets/marketing/1.0.2/app_store/creative_assets/header-es-ES-3840x1646.png` | 3840 × 1646 (21:9) |
| Search Results | English (U.S.) | `store_assets/marketing/1.0.2/app_store/creative_assets/search-results-en-US-3840x2560.png` | 3840 × 2560 (3:2) |
| Search Results | Spanish (Latin America) | `store_assets/marketing/1.0.2/app_store/creative_assets/search-results-es-419-3840x2560.png` | 3840 × 2560 (3:2) |
| Search Results | Spanish (Spain) | `store_assets/marketing/1.0.2/app_store/creative_assets/search-results-es-ES-3840x2560.png` | 3840 × 2560 (3:2) |

Only upload a Spanish (Spain) asset if that App Store localization is enabled.
The prepared English and Latin American Spanish files match the current
storefront content plan.

## Premium gate — all items required before enabling checkout

- [ ] Deploy an authenticated HTTPS purchase-verification endpoint following
      `store_assets/monetization/1.0.2/VERIFICATION_PROTOCOL.md`.
- [ ] Keep production credentials and store server keys out of the repository.
- [ ] Create and submit `chorejar_premium_monthly` and
      `chorejar_premium_yearly` in both stores, with accurate localized copy.
- [ ] Confirm the reference prices of USD 0.99 monthly and USD 9.99 yearly,
      then display the actual storefront price, tax and currency returned by
      the store SDK.
- [ ] Test purchase, restore, renewal, cancellation, billing retry, refund,
      expiration, family-account change and offline recovery in Apple Sandbox
      and Google Play license testing.
- [ ] Update App Store App Privacy and Google Play Data safety from the final
      signed AAB/IPA and server data flow.
- [ ] Build the release only with `SUBSCRIPTIONS_ENABLED=true` and an owned
      HTTPS `SUBSCRIPTION_VERIFY_URL` after every preceding check passes.
- [ ] Add complete reviewer notes and an active review route immediately before
      submission. Never put a real parent password, pairing code or secret in
      this repository.

## Release-owner checks in App Store Connect

1. Confirm category **Lifestyle** and **Made for Kids: No**.
2. Confirm the privacy-policy URL and support contact are live.
3. Upload Header/Search Results assets and inspect the preview on each enabled
   localization.
4. Attach only screenshots from the actual 1.0.2 build.
5. When Premium is complete, select the two submitted subscriptions, attach the
   final build, populate the review notes, and submit them together.
6. Set automatic release only after the account holder has reviewed all legal,
   banking, tax, pricing and availability choices.

## Authoritative references

- Apple: [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- Apple: [Creative asset specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/creative-assets-specifications)
- Apple: [App Store asset best practices](https://developer.apple.com/app-store/asset-best-practices/)
