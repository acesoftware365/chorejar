# Localization and regional listing plan

The current build intentionally exposes only English and Spanish in the app.
Store copy and promotional graphics are provided in `en-US`, `es-419`, and
`es-ES`; no other language is enabled or claimed as translated.

## Current release

| Store locale | In-app language | Store name |
| --- | --- | --- |
| en-US | English | ChoreJar |
| es-419 | Spanish | Mi Mesadita |
| es-ES | Spanish | Mi Paga |

Google Play country-specific custom listings should follow the regional name
matrix in `store/country-branding.md`. App Store localizations should use the
same source copy, subject to each locale's title limits.

## Priority queue for a later localized release

These are market/localization candidates only. They are **not** translated,
enabled, or ready to submit in version 1.0.0.

1. English (United States, United Kingdom, Canada, Australia)
2. Spanish, Latin America
3. Spanish, Spain
4. Portuguese, Brazil
5. French
6. German
7. Japanese
8. Korean
9. Chinese, Simplified
10. Italian
11. Arabic
12. Hindi
13. Indonesian
14. Turkish
15. Polish

Before enabling any one of them: translate every visible interface string with
a native reviewer, translate store metadata and screenshots, review currency
formats and the regional allowance term, then test the complete parent and
child flows on a device configured in that locale.
