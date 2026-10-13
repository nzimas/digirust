"""Audit the patcher publication boundary without reading any instrument."""
from pathlib import Path
import hashlib, json, re
ROOT = Path(__file__).resolve().parents[1]
PUBLIC_DIRS = ('Sources', 'Resources', 'Vendor', 'Artwork', 'docs', 'validation', 'tools', '.github', 'web', 'tests')
PUBLIC_FILES = ('README.md', 'NOTICE.md', 'DigiRust-Features.md', 'CHANGELOG.md', 'LICENSE', 'DISCLAIMER.md', 'build.sh', '.gitignore')
FORBIDDEN = {'.syx', '.elf', '.o', '.snap', '.dat', '.log'}
# Complete known stock/generated transport and MAIN images, never publication assets.
FIRMWARE_HASHES = {
 '7e5b8a733d4ab1fdf7e5d22757f7d8eddaa3cbf71d0858874a791844c02ceb35',
 '9e934872b0a88df389db32235ce491bbff18f35b45bd47d654d1986e13f26bda',
 'a098f620019b2ad38fd7e0397df39501fb1cf6bc26d0283915f34c49446fdf1a',
 '4469ec0c142b628b457020fa4270bcacc2e4817c63157843d13acc598b2fa8e1',
}
def sha(data): return hashlib.sha256(data).hexdigest()
def public_files():
 result = [ROOT / n for n in PUBLIC_FILES]
 for directory in PUBLIC_DIRS:
  result.extend(p for p in (ROOT / directory).rglob('*') if p.is_file() and '__pycache__' not in p.parts)
 return sorted(set(result))
def check_asset(name, data):
 assert Path(name).suffix.lower() not in FORBIDDEN, f'Firmware/research file: {name}'
 assert sha(data) not in FIRMWARE_HASHES, f'Complete firmware: {name}'
 if Path(name).suffix == '.bin': assert Path(name).name == 'additions.bin', f'Unexpected binary: {name}'
def audit():
 files = public_files()
 for p in files:
  assert p.exists() and not p.is_symlink(), p
  check_asset(str(p.relative_to(ROOT)), p.read_bytes())
 for name in ['firmware-patch.json', 'additions.bin']:
  web = ROOT / 'web/assets' / name
  if web.exists(): assert web.read_bytes() == (ROOT / 'Resources' / name).read_bytes(), name
 pins = (ROOT / 'Sources/Pins.swift').read_text()
 for symbol, name in [('recipePin', 'firmware-patch.json'), ('additionsPin', 'additions.bin')]:
  pin = re.search(symbol + r' = "([0-9a-f]{64})"', pins).group(1)
  assert sha((ROOT / 'Resources' / name).read_bytes()) == pin, name
 for name in ['LICENSE', 'DISCLAIMER.md', 'Resources/GCC-GPL.txt', 'Resources/GCC-Runtime-Exception.txt', 'Vendor/elektron-firmware-tool/LICENSE', 'Vendor/elektron-firmware-tool/PROVENANCE.md']:
  assert (ROOT / name).stat().st_size > 0, name
 print(json.dumps({'publicationFiles': len(files), 'resourcePinsPassed': True, 'completeKnownFirmwareAbsent': True, 'instrumentAccessed': False}, indent=2))
 return files
if __name__ == '__main__': audit()
