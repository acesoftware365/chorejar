# ChoreJar 1.0.1 (11) — App Store Connect upload manifest

Prepared October 16, 2026 for the initial iOS submission.

## What to upload

App Store Connect accepts one to ten screenshots per iPhone display family.
The following five JPEGs are the final **iPhone 17 Pro Max / 6.9-inch**
portrait set. Each is `1320 × 2868`, contains no alpha channel and uses
synthetic family data. Use the files in the listed order.

### English (United States)

1. `screenshots/upload/en-US/01-parent-tasks-iphone-17-pro-max.jpg` — a parent assigns and reviews chores.
2. `screenshots/upload/en-US/02-parent-money-iphone-17-pro-max.jpg` — a parent records money already handled outside the app.
3. `screenshots/upload/en-US/03-child-tasks-iphone-17-pro-max.jpg` — a child views chores and submits progress for review.
4. `screenshots/upload/en-US/04-child-money-iphone-17-pro-max.jpg` — a child sees parent-recorded categories and history.
5. `screenshots/upload/en-US/05-child-goal-iphone-17-pro-max.jpg` — a child follows a savings goal; it shows no payout or money-request control.

### Spanish (Latin America)

1. `screenshots/upload/es-419/01-tareas-padre-iphone-17-pro-max.jpg`
2. `screenshots/upload/es-419/02-dinero-padre-iphone-17-pro-max.jpg`
3. `screenshots/upload/es-419/03-tareas-nino-iphone-17-pro-max.jpg`
4. `screenshots/upload/es-419/04-dinero-nino-iphone-17-pro-max.jpg`
5. `screenshots/upload/es-419/05-meta-nino-iphone-17-pro-max.jpg`

The `en-US` and `es-419` text and visual order are matched. Spanish (Spain)
metadata is ready, but do not add a separate Spain screenshot set until every
visible term is reviewed for that localization.

## Listing material ready in this folder

- `metadata/en-US.txt`, `metadata/es-419.txt`, and `metadata/es-ES.txt`:
  name, subtitle, promotional text, description, keywords, URLs and review
  notes.
- `release-notes.md`, `release-notes-es-419.md`, and
  `release-notes-es-ES.md`: version 1.0.1 release notes.
- `../marketing/1.0.1/app_store/`: optional external campaign artwork for
  English and Spanish. App Store Connect does **not** use a Google Play-style
  feature graphic, so it must not replace the device screenshots.

## App preview video

An App Store preview video is optional. None is included because every frame
must show the actual 1.0.1 app; the five device screenshots above are complete
and are the correct material to upload for this submission.

## Final console checks

Before submitting, attach build `1.0.1 (11)`, apply the matching localization
text, answer App Privacy from the final signed binary, confirm the privacy,
support and deletion URLs, and keep automatic release selected after approval.
