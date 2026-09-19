/* ══════════════════════════════════════════════════════════════════════════
   PROJECT AURA — STAGING CONFIG  (edit this ONE file, nothing else)
   --------------------------------------------------------------------------
   This is the TEST/staging portal. It must point at your SANDBOX backend,
   never the live one. Paste your test endpoints below.

   How to get these values (see AURA_SETUP.md for the full walkthrough):
     EXEC       = the /exec URL of your TEST Apps Script deployment
                  (bound to a COPY of the Google Sheet — not the live sheet)
     LOGIN      = the /exec URL of the TEST login backend
                  (usually the SAME as EXEC unless you split login out)
     SUPA_URL   = your TEST Supabase project URL
     SUPA_KEY   = that project's ANON (public) key  — NEVER the service key

   ⚠ Leave these as PASTE_… until the sandbox backend exists. While they say
   PASTE_…, the staging site will simply fail to fetch — which is the point:
   it can never touch real payroll by accident.
   ══════════════════════════════════════════════════════════════════════════ */
window.__AURA__ = {
  ENV:      "staging",
  EXEC:     "https://script.google.com/macros/s/AKfycbxzoQySPU1o4YwN4mp83hNvqqWOaIbNYntL0d8AVtQI8bFwGefPLvWY9Kb7oadpP58y/exec",       // TEST Apps Script /exec
  LOGIN:    "https://script.google.com/macros/s/AKfycbxzoQySPU1o4YwN4mp83hNvqqWOaIbNYntL0d8AVtQI8bFwGefPLvWY9Kb7oadpP58y/exec",      // TEST login /exec (same as EXEC)
  SUPA_URL: "https://zerqudzpdlsktxzhcmpf.supabase.co",       // TEST Supabase project URL
  SUPA_KEY: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InplcnF1ZHpwZGxza3R4emhjbXBmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk4MTE3ODgsImV4cCI6MjEwNTM4Nzc4OH0.RZ0YTCQU4w8PYw49BFxzEvLouZpVfPfDHxSX2EoOXcs"   // TEST Supabase ANON key (public)
};

/* Visible STAGING badge so nobody confuses this with portal.jmbvirtuals.com */
(function(){
  function paint(){
    if (document.getElementById('__aura_badge')) return;
    var b = document.createElement('div');
    b.id = '__aura_badge';
    b.textContent = 'AURA · STAGING';
    b.style.cssText = 'position:fixed;left:8px;bottom:8px;z-index:2147483647;'
      + 'font:700 10px/1 system-ui,sans-serif;letter-spacing:.08em;'
      + 'padding:5px 9px;border-radius:999px;color:#fff;pointer-events:none;'
      + 'background:linear-gradient(90deg,#7c3aed,#db2777);box-shadow:0 2px 10px rgba(0,0,0,.35)';
    (document.body||document.documentElement).appendChild(b);
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', paint);
  else paint();
})();
