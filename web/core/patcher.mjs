// DigiRust browser port of the bundled MIT-licensed firmware-format tool.
// Byte-identical level-0 packing and transport; only pinned Digitone II input.
export class PatchError extends Error {}
export const PINS = Object.freeze({
  recipe: '100eed55b5374db3f7ddd678ade4f9d1a13d2548afe9a08e6915699c6e3adf5e',
  additions: '7fbfed6f33ba8a775c3c38535860c94116aaa7b791a98f78708e3b1a0872b536',
  stock: '7e5b8a733d4ab1fdf7e5d22757f7d8eddaa3cbf71d0858874a791844c02ceb35',
  output: '9e934872b0a88df389db32235ce491bbff18f35b45bd47d654d1986e13f26bda',
});
const check = (ok, text) => { if (!ok) throw new PatchError(text); };
const equal = (a, b) => a.length === b.length && a.every((v, i) => v === b[i]);
const be32 = (b, p) => new DataView(b.buffer, b.byteOffset, b.byteLength).getUint32(p);
const put32 = (b, p, v) => new DataView(b.buffer, b.byteOffset, b.byteLength).setUint32(p, v);
const align = n => Math.ceil(n / 16) * 16;
const hex = b => Array.from(b, v => v.toString(16).padStart(2, '0')).join('');
const hashBytes = async b => new Uint8Array(await crypto.subtle.digest('SHA-256', b));
export const digest = async b => hex(await hashBytes(b));
const hmac = async (key, b) => {
  const k = await crypto.subtle.importKey('raw', key, {name:'HMAC', hash:'SHA-256'}, false, ['sign']);
  return new Uint8Array(await crypto.subtle.sign('HMAC', k, b));
};
export async function validateStock(raw) {
  check(raw instanceof Uint8Array && raw.length > 0 && raw.length < 16_000_000,
    'Choose the extracted official Digitone II OS 1.12 .syx file.');
  check(await digest(raw) === PINS.stock,
    'Unsupported file. Only the exact official Digitone II OS 1.12 .syx is accepted. ZIP archives, other instruments and modified firmware cannot be patched.');
}
class Buffer {
  constructor(cap = 1 << 20) { this.a = new Uint8Array(cap); this.n = 0; }
  room(n) { check(this.n + n <= 64 * 1024 * 1024, 'Firmware buffer exceeded its limit.'); if (this.n+n>this.a.length) { const a=new Uint8Array(Math.max(this.a.length*2,this.n+n)); a.set(this.a); this.a=a; } }
  byte(v) { this.room(1); this.a[this.n++]=v; }
  append(a) { this.room(a.length); this.a.set(a,this.n); this.n+=a.length; }
  zero(n) { this.room(n); this.a.fill(0,this.n,this.n+n); this.n+=n; }
  bytes() { return this.a.slice(0,this.n); }
}
function packetSum(m, base) { let s=base; for(let i=0;i<119;i++)s+=m[6+i]^(base+i); return s&127; }
export function decode(raw) {
  const msgs=[];
  for(let p=0;p<raw.length;) {
    check(raw[p]===0xf0,'Invalid SysEx framing.'); const end=raw.indexOf(0xf7,p+1);
    check(end>p,'Incomplete SysEx message.'); const m=raw.subarray(p+1,end);
    check(m[0]===0&&m[1]===0x20&&m[2]===0x3c&&m[3]===0x15&&m.every(v=>v<128),'Not a Digitone II update.');
    msgs.push(m);p=end+1;
  }
  check(msgs.length>=3,'Incomplete update.');
  const first=msgs[0],last=msgs.at(-1);
  check(first.length===14&&first[5]===127&&first[6]===1&&last.length===14&&last[5]===127&&last[6]===2,'Invalid update markers.');
  const info=first.slice(7,14),count=(info[4]<<14)|(info[5]<<7)|info[6];
  check(count===msgs.length-2,'Packet count mismatch.');
  const stream=new Buffer(count*101);
  for(let k=1;k<msgs.length-1;k++) {
    const m=msgs[k];check(m.length===126&&m[5]===126&&m[125]===packetSum(m,info[0]),'Packet integrity check failed.');
    for(let i=9;i<125;i+=8)for(let j=0;j<7&&i+1+j<125;j++)stream.byte(m[i+1+j]|(((m[i]>>(6-j))&1)<<7));
  }
  const body=stream.bytes();check(body.length>=40,'Truncated container.');
  const len=be32(body,0);check(len>=64&&len+8<=body.length,'Invalid container size.');
  const blob=body.slice(8,len+8);check(String.fromCharCode(...blob.subarray(0,4))==='ELE3','Unsupported container.');
  let sum=0;for(let i=0;i<Math.floor(blob.length/4);i++)sum=(sum+((i+1)^be32(blob,i*4)))>>>0;
  check(sum===be32(body,4),'Container checksum mismatch.');
  const n=be32(blob,28);check(n>0&&n<=64&&32+n*16<=blob.length,'Invalid section table.');
  const sections=[];
  for(let i=0;i<n;i++) {
    const p=32+i*16,s={index:i,id:be32(blob,p),offset:be32(blob,p+4),size:be32(blob,p+8)};
    check(s.offset>=32+n*16&&s.size>0&&s.offset+s.size<=blob.length-32,'Section exceeds container bounds.');sections.push(s);
  }
  check(new Set(sections.map(s=>s.id)).size===n,'Duplicate sections.');
  return {blob,sections,info};
}
export function depack(src, tolerant=false) {
  check(src.length>=8,'Truncated compressed section.');let p=8,tag=0,last=1;
  const out=new Buffer();
  const byte=()=>{if(p>=src.length)throw new PatchError('Truncated compressed data.');return src[p++];};
  const bit=()=>{tag<<=1;if((tag&255)===0){const b=byte();tag=(b<<1)|1;return b>>>7;}return(tag>>>8)&1;};
  const gamma=()=>{let v=1;for(;;){v=(v<<1)+bit();if(bit())return v;check(v<=0x02000000,'Invalid compressed length.');}};
  try {
    for(;;) {
      if(bit()){out.byte(byte());continue;}
      const g=gamma();let off;
      if(g===2)off=last;
      else {const raw=((g<<8)+byte())>>>0;if(raw===767)break;off=(raw-767)>>>0;last=off;}
      const small=2*bit()+bit();let len=(small||gamma()+2)+(off>3328?1:0)+1;
      check(off>0&&off<=out.n,'Invalid compressed offset.');out.room(len);
      for(let i=0;i<len;i++){out.a[out.n]=out.a[out.n-off];out.n++;}
    }
  } catch(e) { if(!tolerant||!out.n||e.message!=='Truncated compressed data.')throw e; }
  check(out.n>0,'Empty compressed section.');return out.bytes();
}
const gammaCost=v=>2*(31-Math.clz32(v));
const matchCost=(off,len,last)=>1+(off===last?2:gammaCost((off+767)>>>8)+8)+
  ((len-1-(off>3328?1:0))<=3?2:2+gammaCost(len-3-(off>3328?1:0)));
// Same candidate order, strict tie-breaking and dynamic-programming parse as
// Vendor/elektron-firmware-tool/aplib.c, ap_pack(..., level=0).
export function pack(data) {
  if(data.length===0)return new Uint8Array(8);
  const n=data.length,head=new Int32Array(1<<17).fill(-1),prev=new Int32Array(n);
  const cost=new Uint32Array(n+1).fill(0xffffffff),lo=new Uint32Array(n+1),from=new Int32Array(n+1),off=new Uint32Array(n+1),len=new Uint32Array(n+1);
  cost[0]=0;lo[0]=1;from[0]=-1;
  const relax=(p,c,l,f,o,t)=>{if(c<cost[p]){cost[p]=c;lo[p]=l;from[p]=f;off[p]=o;len[p]=t;}};
  const hash=i=>((data[i]<<8)^data[i+1])&131071;
  const run=(a,b,cap)=>{let l=0;while(l<cap&&data[a+l]===data[b+l])l++;return l;};
  for(let i=0;i<n;i++) {
    if(cost[i]===0xffffffff)continue;const bi=cost[i],last=lo[i],cap=Math.min(n-i,2048);
    relax(i+1,bi+9,last,i,0,0);
    if(i+1<n) {
      if(i>=last){const rl=run(i-last,i,cap);for(let cl=last>3328?3:2;cl<=rl;cl++)relax(i+cl,bi+matchCost(last,cl,last),last,i,last,cl);}
      let j=head[hash(i)],chain=16,pm=1;
      while(j>=0&&chain--) {
        const o=i-j;if(o>1<<20||pm>=cap)break;
        if(data[j+pm]!==data[i+pm]){j=prev[j];continue;}
        const l=run(j,i,cap);
        if(l>pm){for(let cl=Math.max(pm+1,o>3328?3:2);cl<=l;cl++)relax(i+cl,bi+matchCost(o,cl,last),o,i,o,cl);pm=l;if(l>=cap)break;}
        j=prev[j];
      }
      const h=hash(i);prev[i]=head[h];head[h]=i;
    }
  }
  let count=0;for(let j=n;j>0;j=from[j])count++;
  const path=new Uint32Array(count);for(let j=n,k=count;j>0;j=from[j])path[--k]=j;
  const out=new Buffer(Math.ceil(n*1.5)+256);out.zero(8);let tagPos=-1,tagBits=0,last=1;
  const bit=v=>{if(!tagBits){tagPos=out.n;out.byte(0);tagBits=8;}if(v)out.a[tagPos]|=1<<(tagBits-1);tagBits--;};
  const gamma=v=>{for(let i=30-Math.clz32(v);i>=0;i--){bit((v>>>i)&1);bit(i===0);}};
  for(const p of path) {
    if(!len[p]){bit(1);out.byte(data[from[p]]);continue;}
    bit(0);const o=off[p];if(o===last)gamma(2);else{gamma((o+767)>>>8);out.byte((o+767)&255);last=o;}
    const base=len[p]-1-(o>3328?1:0);if(base<=3){bit(base>>1);bit(base&1);}else{bit(0);bit(0);gamma(base-2);}
  }
  bit(0);gamma(0x1000002);out.byte(255);
  const bytes=out.bytes();put32(bytes,0,bytes.length-8);let sum=0;for(let i=8;i<bytes.length;i++)sum=(sum+bytes[i])>>>0;put32(bytes,4,sum);return bytes;
}
async function findKey(blob,sections) {
  const anchor=[0xbe,0xf9,0xa3,0xf7,0xc6,0x71,0x78,0xf2];
  for(const s of sections) {
    let bytes;try{bytes=depack(blob.subarray(s.offset,s.offset+s.size),true);}catch{continue;}
    for(let i=bytes.indexOf(anchor[0]);i>=0&&i+8<=bytes.length;i=bytes.indexOf(anchor[0],i+1)) {
      if(!anchor.every((v,k)=>bytes[i+k]===v))continue;
      const start=i+8;let p=start;while(p<bytes.length&&bytes[p]>=32&&bytes[p]<127&&p-start<64)p++;
      if(p===start||bytes[p]!==0||p+33>bytes.length)continue;
      const text=bytes.slice(start,p),a=await hashBytes(text),b=await hashBytes(text.slice().reverse());
      const key=a.map((v,k)=>v^b[k]^bytes[p+1+k]);
      if(equal(await hmac(key,blob.subarray(0,blob.length-32)),blob.subarray(blob.length-32)))return key;
    }
  }
  throw new PatchError('The original container signature could not be verified.');
}
export function applyRecipe(main,additions,recipe) {
  check(recipe.format===1&&Number.isSafeInteger(recipe.outputSize)&&recipe.outputSize>0&&recipe.outputSize<8_000_000&&Array.isArray(recipe.operations),'Invalid patch format.');
  const output=new Uint8Array(recipe.outputSize);let p=0;
  for(const op of recipe.operations) {
    check(Array.isArray(op)&&op.length===3&&op.every(Number.isSafeInteger)&&(op[0]===0||op[0]===1)&&op[1]>=0&&op[2]>0,'Invalid patch operation.');
    const source=op[0]===0?main:additions;check(op[1]+op[2]<=source.length&&p+op[2]<=output.length,'Patch operation exceeds bounds.');
    output.set(source.subarray(op[1],op[1]+op[2]),p);p+=op[2];
  }
  check(p===output.length,'Patch output length mismatch.');return output;
}
export function encode(blob,info) {
  const count=Math.floor((8+blob.length)/101)+1,stream=new Uint8Array(count*101);put32(stream,0,blob.length);
  let sum=0;for(let i=0;i<Math.floor(blob.length/4);i++)sum=(sum+((i+1)^be32(blob,i*4)))>>>0;put32(stream,4,sum);stream.set(blob,8);
  const out=new Buffer((count+2)*128);const marker=kind=>{const m=Uint8Array.from([0,32,60,21,0,127,kind,...info]);m[11]=(count>>>14)&127;m[12]=(count>>>7)&127;m[13]=count&127;out.byte(240);out.append(m);out.byte(247);};
  marker(1);const block=(info[1]<<7)|info[2],seq=info[3];
  for(let k=0;k<count;k++) {
    const m=new Uint8Array(126),cum=seq+k,b=block+(cum>>>7);m.set([0,32,60,21,0,126,(b>>>7)&127,b&127,cum&127]);
    let dest=9;for(let i=k*101;i<(k+1)*101;i+=7){const ms=dest++;for(let j=0;j<7&&i+j<(k+1)*101;j++){m[ms]|=(stream[i+j]>>>7)<<(6-j);m[dest++]=stream[i+j]&127;}}
    m[125]=packetSum(m,info[0]);out.byte(240);out.append(m);out.byte(247);
  }
  marker(2);return out.bytes();
}
export async function patch(raw,recipeBytes,additions,progress=()=>{}) {
  progress(5,'Checking official OS 1.12');await validateStock(raw);
  check(await digest(recipeBytes)===PINS.recipe&&await digest(additions)===PINS.additions,'Patch resource integrity check failed. Reload the site and try again.');
  const recipe=JSON.parse(new TextDecoder().decode(recipeBytes));
  progress(15,'Unpacking your operating system');const parsed=decode(raw),{blob,sections,info}=parsed;
  const main=sections.find(s=>s.id===3);check(main,'MAIN OS section missing.');
  const original=depack(blob.subarray(main.offset,main.offset+main.size));check(await digest(original)===recipe.mainInputSHA256,'Stock MAIN integrity check failed.');
  progress(30,'Applying DigiRust RC17');const image=applyRecipe(original,additions,recipe);check(await digest(image)===recipe.mainOutputSHA256,'Modified MAIN integrity check failed.');
  progress(45,'Compressing the modified operating system');const packed=pack(image);check(equal(depack(packed),image),'Compression round-trip failed.');
  progress(75,'Rebuilding and verifying the package');const key=await findKey(blob,sections),out=new Buffer(blob.length+packed.length);
  const first=Math.min(...sections.map(s=>s.offset));out.append(blob.subarray(0,first));
  for(const s of [...sections].sort((a,b)=>a.offset-b.offset)) {
    const p=align(out.n);out.zero(p-out.n);const bytes=s.id===3?packed:blob.subarray(s.offset,s.offset+s.size);out.append(bytes);
    put32(out.a,32+s.index*16+4,p);put32(out.a,32+s.index*16+8,bytes.length);
  }
  out.zero(align(out.n+4)-out.n);out.append(await hmac(key,out.bytes()));key.fill(0);
  const result=encode(out.bytes(),info);check(await digest(result)===PINS.output&&recipe.outputSHA256===PINS.output,'Final RC17 package differs from the verified reference. Nothing will be downloaded.');
  const rebuilt=decode(result);for(const s of sections.filter(s=>s.id!==3)){const r=rebuilt.sections.find(r=>r.id===s.id);check(r&&equal(blob.subarray(s.offset,s.offset+s.size),rebuilt.blob.subarray(r.offset,r.offset+r.size)),'Protected section changed.');}
  progress(100,'RC17 verified — ready to download');return result;
}
