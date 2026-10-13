import assert from 'node:assert/strict';
import {readFile,writeFile,mkdtemp,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {execFileSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import {pack,depack,applyRecipe,validateStock,patch,digest,PINS} from '../web/core/patcher.mjs';
const root=fileURLToPath(new URL('../',import.meta.url));let cases=0;
const test=async(name,fn)=>{await fn();cases++;console.log('PASS',name);};
const temp=await mkdtemp(join(tmpdir(),'digirust-web-tests-'));
try{
 const native=join(temp,'codec');
 execFileSync(process.env.CC||'cc',['-O2','-I',root+'Vendor/elektron-firmware-tool',root+'tests/native_codec.c',root+'Vendor/elektron-firmware-tool/aplib.c','-o',native]);
 let seed=0x31a837;const random=n=>Uint8Array.from({length:n},()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed>>>24;});
 const datasets=[new Uint8Array(),Uint8Array.of(2),Uint8Array.of(1,1),random(2048),new Uint8Array(5000),Uint8Array.from({length:11000},(_,i)=>i%127),(()=>{let b=random(16000);b.set(b.subarray(20,800),7000);return b;})()];
 for(let i=0;i<datasets.length;i++)await test('C/JS codec parity '+i,async()=>{const b=datasets[i],source=join(temp,'source'),target=join(temp,'packed');await writeFile(source,b);execFileSync(native,[source,target]);const js=pack(b);assert.deepEqual(js,new Uint8Array(await readFile(target)));if(b.length)assert.deepEqual(depack(js),b);});
 await test('reject truncated compressed data',()=>assert.throws(()=>depack(Uint8Array.of(0,0,0,0,0,0,0,0))));
 await test('reject empty stock',()=>assert.rejects(validateStock(new Uint8Array())));
 await test('reject oversized stock',()=>assert.rejects(validateStock(new Uint8Array(16_000_000))));
 await test('reject arbitrary stock',()=>assert.rejects(validateStock(Uint8Array.of(1,2,3))));
 await test('COPY/ADD recipe exact scopes',()=>assert.deepEqual(applyRecipe(Uint8Array.of(1,2,3),Uint8Array.of(7,8),{format:1,outputSize:4,operations:[[0,1,2],[1,0,2]]}),Uint8Array.of(2,3,7,8)));
 for(const op of [[2,0,1],[0,-1,1],[0,0,4],[1,0,0],[0,0,1.5]])await test('reject invalid recipe '+JSON.stringify(op),()=>assert.throws(()=>applyRecipe(Uint8Array.of(1,2,3),new Uint8Array(1),{format:1,outputSize:4,operations:[op]})));
 await test('reject short recipe output',()=>assert.throws(()=>applyRecipe(new Uint8Array(3),new Uint8Array(1),{format:1,outputSize:3,operations:[[0,0,2]]})));
 const stockPath=process.argv[2];
 if(stockPath){
  const raw=new Uint8Array(await readFile(stockPath)),original=raw.slice(),recipe=new Uint8Array(await readFile(root+'web/assets/firmware-patch.json')),additions=new Uint8Array(await readFile(root+'web/assets/additions.bin'));
  let result;const start=Date.now();
  await test('exact complete RC17 output and unchanged input',async()=>{result=await patch(raw,recipe,additions);assert.equal(await digest(result),PINS.output);assert.equal(result.length,2483616);assert.deepEqual(raw,original);});
  await test('reject modified firmware as input',()=>assert.rejects(patch(result,recipe,additions)));
  await test('reject one-bit stock corruption',()=>{const b=raw.slice();b[300]^=1;return assert.rejects(patch(b,recipe,additions));});
  await test('reject wrong-instrument file',()=>{const b=raw.slice();b[4]=0x0e;return assert.rejects(patch(b,recipe,additions));});
  await test('reject tampered recipe',()=>{const b=recipe.slice();b[10]^=1;return assert.rejects(patch(raw,b,additions));});
  await test('reject tampered additions',()=>{const b=additions.slice();b[0]^=1;return assert.rejects(patch(raw,recipe,b));});
  console.log('EXACT_PACKAGE_SECONDS',((Date.now()-start)/1000).toFixed(2));
 }
 console.log(JSON.stringify({passed:cases,exactPackageTest:!!stockPath,outputSHA256:stockPath?PINS.output:null,instrumentAccessed:false}));
}finally{await rm(temp,{recursive:true,force:true});}
