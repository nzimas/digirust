"""Check static links, publication boundary and browser-only processing inputs."""
from pathlib import Path
from html.parser import HTMLParser
from urllib.parse import urlsplit,unquote
import json,hashlib
ROOT=Path(__file__).resolve().parents[1];WEB=ROOT/'web'
class Page(HTMLParser):
 def __init__(self):super().__init__();self.links=[];self.ids=set();self.h1=0
 def handle_starttag(self,tag,attrs):
  a=dict(attrs)
  if 'id' in a:assert a['id'] not in self.ids;self.ids.add(a['id'])
  if tag=='h1':self.h1+=1
  for key in ('href','src'):
   if key in a:self.links.append(a[key])
pages={}
for f in WEB.glob('*.html'):
 p=Page();p.feed(f.read_text());assert p.h1==1,f;pages[f.name]=p
for name,p in pages.items():
 for link in p.links:
  u=urlsplit(link)
  if u.scheme or u.netloc:continue
  target=(WEB/unquote(u.path or name)).resolve()
  assert target.is_relative_to(WEB),link
  assert target.exists(),(name,link)
  if u.fragment and target.name in pages:assert u.fragment in pages[target.name].ids,(name,link)
for name in ('firmware-patch.json','additions.bin'):assert (WEB/'assets'/name).read_bytes()==(ROOT/'Resources'/name).read_bytes()
for f in WEB.rglob('*'):
 if f.is_file():assert f.suffix.lower() not in {'.syx','.snap','.elf','.dat','.o'},f
engine=(WEB/'core/patcher.mjs').read_text();worker=(WEB/'core/worker.mjs').read_text()
assert 'requestMIDIAccess' not in engine+worker+(WEB/'app.mjs').read_text()
assert 'fetch(' not in engine
assert worker.count('fetch(')==1 and "new URL('../assets/'" in worker
assert '100eed55b5374db3f7ddd678ade4f9d1a13d2548afe9a08e6915699c6e3adf5e' in engine
print(json.dumps({'pages':list(pages),'localLinksPassed':True,'resourcesMatchMacOSPatcher':True,'completeFirmwareIncluded':False,'browserHasNoInstrumentAccess':True},indent=2))
