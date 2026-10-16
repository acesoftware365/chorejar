'use strict';
// No Firebase, analytics or external requests: a preview never consumes a code.
const en = !navigator.language.toLowerCase().startsWith('es');
const $ = id => document.getElementById(id);
const parent = location.pathname === '/join-parent';
const route = parent ? 'join-parent' : 'join-child';
const validRoute = location.pathname === '/join-child' || parent;
const code = new URLSearchParams(location.hash.slice(1) || location.search).get('code');
const valid = validRoute && /^[0-9a-f]{32}$/i.test(code || '');
document.documentElement.lang = en ? 'en' : 'es';
document.title = en ? 'ChoreJar · Connect with my family' : 'ChoreJar · Conectar con mi familia';
$('title').textContent = parent ? (en ? 'Join my family' : 'Unirme a mi familia') : (en ? 'Connect with my family' : 'Conectar con mi familia');
$('intro').textContent = en ? 'Open this link on the phone or tablet you want to connect.' : 'Abre este enlace en el teléfono o tableta que quieres vincular.';
$('expiry').textContent = en ? 'ChoreJar must be installed. Both devices need internet. Wi-Fi works too. This single-use link expires in 10 minutes.' : 'Necesitas ChoreJar instalado. Ambos dispositivos necesitan internet; también funciona con Wi-Fi. El enlace es de un solo uso y vence en 10 minutos.';
if (valid) {
  $('open').hidden = false;
  $('open').href = `chorejar://${route}?code=${code.toLowerCase()}`;
  $('open').textContent = en ? 'Open ChoreJar' : 'Abrir ChoreJar';
  $('help').textContent = en ? 'Then tap Pair device in the app.' : 'Después toca Vincular dispositivo en la app.';
  if (parent) $('help').textContent = en ? 'Sign in with your own parent account to accept the invitation.' : 'Entra con tu propia cuenta de padre para aceptar la invitación.';
  $('fallback').hidden = false;
  $('manualTitle').textContent = en ? 'App did not open?' : '¿No se abre?';
  $('manual').textContent = parent
    ? (en ? 'Open ChoreJar, choose I have an invitation and paste this code.' : 'Abre ChoreJar, elige Tengo una invitación y pega este código.')
    : (en ? 'Open ChoreJar, choose I’m a child and paste this code.' : 'Abre ChoreJar, elige Soy niño y pega este código.');
  $('code').textContent = code.toLowerCase();
  $('copy').textContent = en ? 'Copy code' : 'Copiar código';
  $('copy').addEventListener('click', async () => {
    try { await navigator.clipboard.writeText(code.toLowerCase()); $('status').textContent = en ? 'Copied. Paste it in ChoreJar.' : 'Copiado. Pégalo en ChoreJar.'; }
    catch { $('status').textContent = en ? 'Press and hold the code to copy it.' : 'Mantén pulsado el código para copiarlo.'; }
  });
} else {
  $('help').textContent = en ? 'This invitation is incomplete. Ask the parent to send a new link from Link device in ChoreJar.' : 'La invitación está incompleta. Pide al padre un enlace nuevo desde Vincular dispositivo en ChoreJar.';
}
