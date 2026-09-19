# JMB Portal — Project Aura (STAGING)

This is a **duplicate / test copy** of the live portal, for building Project Aura.
It is NOT the official portal (portal.jmbvirtuals.com).

## Rules for this repo
- Do NOT restore a `CNAME` pointing at portal.jmbvirtuals.com. Use a separate
  subdomain (e.g. aura.jmbvirtuals.com) or the Netlify default *.netlify.app URL.
- Backend wiring (Apps Script /exec + Supabase) is set per the decision recorded
  when this copy was created. If it points at the LIVE backend, every action here
  writes to REAL payroll data — treat with care.

## Backend endpoints in use
See API_URL / SUPA_URL constants in index.html and admin.html.
