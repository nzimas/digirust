"""Prepare static GitHub Pages resources. Never copies a complete firmware."""
from pathlib import Path
import shutil,json,hashlib
ROOT=Path(__file__).resolve().parents[1];assets=ROOT/'web/assets';licenses=assets/'licenses';licenses.mkdir(exist_ok=True)
for name in ['firmware-patch.json','additions.bin']:shutil.copy2(ROOT/'Resources'/name,assets/name)
for source,name in [('LICENSE','DigiRust-MIT.txt'),('Vendor/elektron-firmware-tool/LICENSE','firmware-tool-MIT.txt'),('Resources/GCC-GPL.txt','GCC-GPL.txt'),('Resources/GCC-Runtime-Exception.txt','GCC-Runtime-Exception.txt')]:shutil.copy2(ROOT/source,licenses/name)
(ROOT/'web/.nojekyll').touch()
print('Static browser patcher prepared: web/')
