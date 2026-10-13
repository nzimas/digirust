const button=document.getElementById('play-demo');
button?.addEventListener('click',()=>{
 const frame=document.createElement('iframe');frame.title='DigiRust demo';frame.src='https://www.youtube-nocookie.com/embed/BoazPrfJgIs?autoplay=1';frame.allow='autoplay; encrypted-media; picture-in-picture; fullscreen';frame.referrerPolicy='strict-origin-when-cross-origin';frame.allowFullscreen=true;
 document.getElementById('demo').replaceChildren(frame);
});
