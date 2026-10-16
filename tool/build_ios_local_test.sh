#!/bin/bash
# Existing registered-device profile; all ads remain TEST. Never a store build.
# Usage: build_ios_local_test.sh Xcode.app installed.mobileprovision output.ipa
set -euo pipefail
chore_root="$(cd "$(dirname "$0")/.." && pwd)"
export DEVELOPER_DIR="$1/Contents/Developer"
chore_profile="$2"
chore_output="$3"
cd "$chore_root"
python3 - <<'PY'
from pathlib import Path
import plistlib
p=plistlib.loads(Path('ios/Runner/Info.plist').read_bytes())
assert p['GADApplicationIdentifier']=='ca-app-pub-3940256099942544~1458002511', 'Test AdMob app ID required'
PY
/Users/juanpolanco/development/flutter/bin/flutter build ios --release --no-codesign \
  --dart-define=ADS_ENABLED=true --dart-define=ADS_LIVE=false
python3 - "$chore_profile" "$chore_output" <<'PY'
from pathlib import Path
import hashlib, plistlib, re, shutil, subprocess, sys, tempfile
profile=Path(sys.argv[1]); output=Path(sys.argv[2]).resolve()
p=plistlib.loads(subprocess.check_output(['security','cms','-D','-i',str(profile)],stderr=subprocess.DEVNULL))
assert p.get('ProvisionedDevices'), 'A registered-device test profile is required'
assert p['Entitlements'].get('get-task-allow'), 'A development profile is required'
team=p['TeamIdentifier'][0]; bundle='com.liisgo.chorejar'
assert p['Entitlements']['application-identifier'] in [team+'.*',team+'.'+bundle]
identities=subprocess.check_output(['security','find-identity','-v','-p','codesigning'],text=True)
identity=next(hashlib.sha1(cert).hexdigest().upper() for cert in p['DeveloperCertificates'] if hashlib.sha1(cert).hexdigest().upper() in identities)
with tempfile.TemporaryDirectory(prefix='chorejar-ios-test-') as temporary:
 root=Path(temporary); payload=root/'Payload';payload.mkdir()
 app=payload/'Runner.app'
 shutil.copytree('build/ios/iphoneos/Runner.app',app,symlinks=True)
 shutil.copy2(profile, app/'embedded.mobileprovision')
 ent=dict(p['Entitlements']);ent['application-identifier']=team+'.'+bundle
 ent['keychain-access-groups']=[team+'.'+bundle]
 # The legacy local profile has no Associated Domains entitlement. HTTPS links
 # use the hosted Open ChoreJar button; canonical store entitlements stay intact.
 entpath=root/'test-entitlements.plist';entpath.write_bytes(plistlib.dumps(ent))
 frameworks=list((app/'Frameworks').glob('*.framework'))+list((app/'Frameworks').glob('*.dylib'))
 for f in frameworks:
  subprocess.run(['codesign','--force','--sign',identity,str(f)],check=True)
 subprocess.run(['codesign','--force','--sign',identity,'--entitlements',str(entpath),str(app)],check=True)
 subprocess.run(['codesign','--verify','--deep','--strict',str(app)],check=True)
 info=plistlib.loads((app/'Info.plist').read_bytes())
 expected=re.search(r'^version: .*\+(\d+)\s*$',Path('pubspec.yaml').read_text(),re.M).group(1)
 assert info['CFBundleVersion']==expected
 assert info['GADApplicationIdentifier']=='ca-app-pub-3940256099942544~1458002511'
 output.parent.mkdir(parents=True,exist_ok=True)
 subprocess.run(['ditto','-c','-k','--keepParent',str(payload),str(output)],check=True)
 print('Created signed development IPA for existing registered test devices. TEST ads only.')
PY
