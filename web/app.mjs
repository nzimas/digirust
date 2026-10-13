const $=id=>document.getElementById(id);
const input=$('firmware'),choose=$('choose'),drop=$('drop'),create=$('create'),cancel=$('cancel'),ack=$('ack'),download=$('download');
let selected=null,valid=false,worker=null,token=0,url=null,busy=false;
function clearDownload(){if(url)URL.revokeObjectURL(url);url=null;download.hidden=true;download.removeAttribute('href');}
function controls(){create.disabled=!valid||!ack.checked||busy;choose.disabled=busy;input.disabled=busy;ack.disabled=busy;cancel.hidden=!busy;}
function status(title,text,type='',percent=0){$('status').className='status '+type;$('status-title').textContent=title;$('status-text').textContent=text;$('progress').value=percent;$('progress').hidden=percent===0;}
function stop(){token++;worker?.terminate();worker=null;busy=false;controls();}
async function start(file,action){
  stop();const request=token;clearDownload();busy=true;controls();
  try {
    if(file.size<=0||file.size>=16_000_000)throw new Error('Choose the extracted official OS 1.12 .syx, smaller than 16 MB.');
    const bytes=await file.arrayBuffer();if(request!==token)return;
    worker=new Worker(new URL('./core/worker.mjs',import.meta.url),{type:'module'});
    worker.onmessage=({data})=>{
      if(request!==token)return;
      if(data.type==='progress'){status(data.text,'Keep this tab open. You can cancel at any time.','',data.value);return;}
      if(data.type==='valid'){valid=true;$('file-hint').textContent='Verified official Digitone II OS 1.12';stop();status('Official OS 1.12 verified','Review the warning below, then create your DigiRust firmware copy.');return;}
      if(data.type==='done'){
        url=URL.createObjectURL(new Blob([data.bytes],{type:'application/octet-stream'}));download.href=url;download.hidden=false;
        stop();status('Your firmware is ready','The complete DigiRust file passed verification. Download it below. Installation is a separate decision.','success',100);download.focus();return;
      }
      valid=action==='patch';stop();status('No output created',data.text,'error');
    };
    worker.onerror=()=>{if(request!==token)return;stop();status('No output created','The browser could not complete the task. Reload and try again in a current browser.','error');};
    worker.postMessage({action,bytes},[bytes]);
  }catch(e){if(request!==token)return;valid=false;stop();status('No output created',e.message,'error');}
}
function select(file){if(!file||busy)return;selected=file;valid=false;ack.checked=false;$('file-name').textContent=file.name;$('file-hint').textContent='Checking file identity on this device…';status('Checking your file','Your file stays on this device.');start(file,'validate');}
choose.onclick=()=>input.click();input.onchange=()=>select(input.files[0]);ack.onchange=controls;
create.onclick=()=>{if(!selected||!valid||!ack.checked||busy)return;status('Creating your firmware','Processing locally in your browser.');start(selected,'patch');};
cancel.onclick=()=>{stop();clearDownload();status('Cancelled','This attempt was cancelled. You can start again.');};
drop.ondragover=e=>{e.preventDefault();if(!busy)drop.classList.add('drag');};drop.ondragleave=()=>drop.classList.remove('drag');
drop.ondrop=e=>{e.preventDefault();drop.classList.remove('drag');if(e.dataTransfer.files.length!==1){clearDownload();valid=false;selected=null;controls();status('Choose one file','Drop a single official OS 1.12 .syx file.','error');return;}select(e.dataTransfer.files[0]);};
window.addEventListener('beforeunload',()=>{worker?.terminate();clearDownload();});
if(!window.isSecureContext||!window.crypto?.subtle||!window.Worker){choose.disabled=true;status('Browser requirements','Use a current browser over HTTPS with Web Crypto and Web Workers enabled.','error');}
else controls();
