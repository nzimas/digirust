"""Package explicitly selected patcher files and documentation, never firmware."""
from pathlib import Path
import json, subprocess, zipfile
from audit_distribution import ROOT, audit, check_asset, sha
VERSION = '1.2.0'
files = audit()
dist = ROOT / 'dist'; app = dist / 'DigiRust.app'
assert app.is_dir(), 'Run ./build.sh first'
subprocess.run(['codesign', '--verify', '--deep', '--strict', str(app)], check=True)
docs = [ROOT / n for n in ('README.md', 'NOTICE.md', 'RC17-Features.md', 'CHANGELOG.md', 'LICENSE', 'DISCLAIMER.md')]
docs += [p for p in (ROOT / 'docs').rglob('*') if p.is_file()]
archives = []
for kind in ('macOS', 'source'):
 target = dist / f'DigiRust-{VERSION}-{kind}.zip'
 prefix = f'DigiRust-{VERSION}' if kind == 'macOS' else 'DigiRust-source'
 contents = [p for p in app.rglob('*') if p.is_file()] + docs if kind == 'macOS' else files
 with zipfile.ZipFile(target, 'w', zipfile.ZIP_DEFLATED) as z:
  for p in sorted(contents):
   data = p.read_bytes(); name = str(Path(prefix) / p.relative_to(dist if p.is_relative_to(app) else ROOT))
   check_asset(name, data); z.write(p, name)
 archives.append({'archive': target.name, 'sha256': sha(target.read_bytes()), 'bytes': target.stat().st_size})
(dist / 'SHA256SUMS.txt').write_text(''.join(a['sha256'] + '  ' + a['archive'] + '\n' for a in archives))
(dist / 'publication-report.json').write_text(json.dumps({'patcherVersion': VERSION, 'firmwareTarget': 'RC17', 'completeFirmwareIncluded': False, 'archives': archives}, indent=2) + '\n')
print(json.dumps(archives, indent=2))
