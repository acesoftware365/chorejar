#!/bin/bash
# Build a Duo simulator test app without changing the machine's selected Xcode.
set -euo pipefail
chore_root="$(cd "$(dirname "$0")/.." && pwd)"
if [ "$#" -gt 0 ]; then export DEVELOPER_DIR="$1/Contents/Developer"; fi
chore_target="${CHORE_TARGET:-lib/main.dart}"
chore_sdk="$(xcrun --sdk iphonesimulator --show-sdk-version)"
python3 - "$chore_sdk" <<'PY'
import sys
version = tuple(int(n) for n in sys.argv[1].split('.')[:2])
if version < (27, 1):
    sys.exit('Duo full-display test requires iOS SDK 27.1 or later; installed SDK is '+sys.argv[1]+'. Pass the path to a separate newer Xcode.app. No build was changed.')
PY
cd "$chore_root"
python3 - <<'PY'
from pathlib import Path
debug_config=Path('ios/Flutter/Debug.xcconfig').read_text()
if 'GAD_APPLICATION_IDENTIFIER=ca-app-pub-3940256099942544~1458002511' not in debug_config:
    raise SystemExit('This test build requires the official iOS sample AdMob app ID.')
PY
"${CHORE_FLUTTER:-/Users/juanpolanco/development/flutter/bin/flutter}" build ios \
  --simulator --debug --no-codesign --config-only \
  --target="$chore_target" \
  --dart-define=ADS_ENABLED=true --dart-define=ADS_LIVE=false
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Debug \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  ARCHS=arm64 ONLY_ACTIVE_ARCH=YES CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  BUILD_DIR="$chore_root/build/ios"
# Sign the simulator bundle ad hoc.  Do not inject device-team entitlements here:
# iOS 27 rejects those ad-hoc entitlements when it launches an app on Duo.
# This is simulator-only; physical-device signing is a separate script.
chore_sim_app="$chore_root/build/ios/Debug-iphonesimulator/Runner.app"
codesign --force --sign - "$chore_sim_app/Runner"
codesign --force --sign - "$chore_sim_app/Runner.debug.dylib"
codesign --force --sign - "$chore_sim_app/__preview.dylib"
codesign --force --sign - "$chore_sim_app"
codesign --verify --deep --strict "$chore_sim_app"
