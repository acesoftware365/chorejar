# Promotional artwork — 1.0.0

This folder is the release source for marketing graphics, not a replacement for
store screenshots captured from the installed app.

## Source artwork

- `source/family-chores-wide.png`: original image-generation artwork with safe
  negative space for localizable copy.
- `source/family-chores-portrait.png`: original portrait artwork with safe
  negative space for localizable copy.

The sources were generated for ChoreJar on 2026-10-16 with no logos, app UI,
currency denomination, store badge, or embedded text. They depict a parent and
child organizing a chore checklist with a savings jar; they do not claim cash
payments or money transfers.

## Generated deliverables

- `google_play/feature-graphic-*.png`: 1024×500 feature graphics.
- `app_store/promo-*.png`: 1200×628 promotional graphics.
- `social/portrait-*.png`: 1080×1350 campaign/social variants.

Run `python3 tool/generate_store_assets.py` after editing either source image
or the approved English/Spanish copy in that script.  The generator is kept
text-only so localizations do not depend on an image model rendering words.

## Screenshot rule

Put real device captures in `store_assets/app_store/1.0.0/screenshots/` and
the matching Google Play screenshot folder. Never submit an image that shows a
test-ad creative, placeholder, account email, or child-identifying data.
