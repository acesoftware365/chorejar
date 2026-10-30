# App Store resubmission — ChoreJar 1.0.2 (12)

On 2026-10-30, Apple rejected submission
`a62da092-2308-40d5-aba1-08f62d90eb3c` under Guideline 2.1 because the
account-based app had no demo credentials in App Review Information.

- Confirmed the supplied review credentials authenticate against the iOS
  project's production Firebase Authentication configuration. This checks
  authentication, not the entire in-app navigation flow.
- Marked **Sign-in required** and saved the user name and password in App Store
  Connect. The credentials are intentionally absent from this repository.
- Updated reviewer notes to explain the parent and child preview flows, and
  that the child view has no ads or checkout.
- Resubmitted the existing 1.0.2 (12) item without a new binary. App Store
  Connect showed **Waiting for Review** after resubmission.
- Automatic release after approval remains selected. The app is not yet
  approved or live from this submission.
