# Project Aura — Staging Portal Setup

This folder is a **full duplicate** of the live portal, wired for a **safe sandbox**.
Nothing here can touch real payroll until *you* point it at a test backend — and the
whole point is that the test backend is a **copy**, so you can break things freely.

All backend endpoints are read from one file: **`aura-config.js`**. You edit that
file once; every page (`index`, `admin`, `m`, `sign`, `rate`, `resign`, `t3-spectate`)
picks it up automatically. Until you fill it in, the site loads but fetches fail — by
design.

---

## The 5 steps

### 1. Copy the Google Sheet (the database)
- Open the **live** portal Sheet → **File → Make a copy** → name it e.g. `JMB Portal DB — AURA TEST`.
- Open the copy and note it exists. (Optional: delete most rows to keep it light — keep the header rows and a few sample rows per tab.)

### 2. Copy & deploy a TEST Apps Script (the backend)
- In the **copied** Sheet → **Extensions → Apps Script**. This opens a script bound to the COPY.
- Paste in your latest `portal-apps-script.gs` (and `login-apps-script.gs` if you use the split login).
- **Set the test properties** (Project Settings → Script properties) — use the COPY's values, never the live ones:
  - `SUPA_URL` = your TEST Supabase URL (step 3)
  - `SUPA_SERVICE_KEY` = TEST Supabase **service** key (you set it; I never see it)
  - `ADMIN_PASS`, and any other secrets — set fresh test values
- **Deploy → New deployment → Web app** → Execute as *me*, Access *Anyone* → **Deploy**.
- Copy the **/exec URL** it gives you. That's your `EXEC` (and `LOGIN`, unless you split them).

> ⚠ Do NOT reuse the live deployment. A test backend must be its own deployment bound to the copied Sheet, so its triggers and writes only ever hit the copy.

### 3. Create TEST Supabase tables
Two options:
- **Simplest — new Supabase project:** create a fresh project, run **`aura-supabase-setup.sql`** (in this folder) in its SQL editor. Use that project's URL + anon key below.
- **Or reuse the same project with `_test` tables:** run `aura-supabase-setup.sql` as-is — it creates `worklog`, `attendance`, `tracker_beat` only `if not exists`, so in a *new* project it's clean. (If you want them inside your existing project without colliding, tell me and I'll rename them to `*_test` in both the SQL and the backend.)

Grab the project **URL** and **anon (public) key** from Supabase → Project Settings → API.

### 4. Fill in `aura-config.js`
Open `aura-config.js` and replace the four `PASTE_…` values:
```js
window.__AURA__ = {
  ENV:      "staging",
  EXEC:     "https://script.google.com/macros/s/……/exec",   // step 2
  LOGIN:    "https://script.google.com/macros/s/……/exec",   // usually same as EXEC
  SUPA_URL: "https://xxxxxxxx.supabase.co",                  // step 3
  SUPA_KEY: "eyJhbGci……"                                    // step 3 anon key
};
```

### 5. Push to a NEW GitHub repo → Netlify
- Create a **new** GitHub repo (e.g. `jmb-portal-aura`) — separate from the live one.
- Upload the contents of this `Portal_V2_Aura` folder ("Add files via upload", same as you do now).
- Connect it to a **new** Netlify site. Use the default `*.netlify.app` URL, or a **separate subdomain** like `aura.jmbvirtuals.com`.
- **Never** add a `CNAME` file pointing at `portal.jmbvirtuals.com` here — that would fight your live site. (I already removed it from this copy.)

---

## Safety notes (baked in)
- The live-domain `CNAME` was **removed** so this repo can't hijack the live URL.
- A purple **"AURA · STAGING"** badge shows bottom-left on every page.
- No live Apps Script or Supabase URL remains anywhere in this copy (verified).
- Secrets (`SUPA_SERVICE_KEY`, `ADMIN_PASS`, Anthropic key, ElevenLabs key) live only in the **test** Script Properties / your own tools. You set them; they never appear in the frontend and I never see them.

## Working live vs offline — recommendation
Work **live on the staging URL**. Opening the HTML offline can't properly exercise logins,
timers, or Aura's backend calls. A live staging site lets you test on real devices, share a
link, and iterate — with zero risk to production because it's a separate backend + separate
data. Use offline only for quick pure-UI/CSS tinkering.

## When Aura is ready to graduate
Once a feature is proven on staging, we port just that change into the **live**
`portal-apps-script.gs` + `portal_site/` and you deploy it the normal way. Staging stays as
your permanent playground for the next thing.
