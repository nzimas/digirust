import {patch,validateStock} from './patcher.mjs';
self.onmessage=async({data})=>{
  try {
    const raw=new Uint8Array(data.bytes);
    if(data.action==='validate'){await validateStock(raw);self.postMessage({type:'valid'});return;}
    const fetchBytes=async name=>{const r=await fetch(new URL('../assets/'+name,import.meta.url),{cache:'no-cache'});if(!r.ok)throw new Error('Patch resources could not be loaded. Check your connection and reload.');return new Uint8Array(await r.arrayBuffer());};
    const [recipe,additions]=await Promise.all([fetchBytes('firmware-patch.json'),fetchBytes('additions.bin')]);
    const result=await patch(raw,recipe,additions,(value,text)=>self.postMessage({type:'progress',value,text}));
    self.postMessage({type:'done',bytes:result.buffer},[result.buffer]);
  } catch(e){self.postMessage({type:'error',text:e.message||'Patching failed. No output was created.'});}
};
