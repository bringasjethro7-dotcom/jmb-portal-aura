-- ══════════════════════════════════════════════════════════════════════════════════════
--  PROJECT AURA — TEST Supabase setup (one file, safe to re-run)
--  Run ONCE in your TEST Supabase project → SQL Editor → New query → paste ALL → Run.
--
--  Mirrors the production schema exactly (worklog + attendance + tracker_beat + vol_status)
--  so the Aura staging backend behaves identically — but against sandbox data.
--
--  Privacy model (same as live): RLS is ON. worklog + attendance have NO anon policies, so
--  only the Apps Script SERVICE key can read/write them. tracker_beat allows anon INSERT
--  only (record a beat, read nothing). The public anon key in the HTML can enumerate nothing.
-- ══════════════════════════════════════════════════════════════════════════════════════

-- ── WorkLog: one row per timer entry ────────────────────────────────────────────────────
create table if not exists public.worklog (
  entry_id     text primary key,        -- = WorkLog clockify_id (stable id)
  employee_id  text,
  full_name    text,
  date         date,
  project      text,
  category     text,
  task         text,
  description  text,
  hours        numeric,
  volume       text,
  status       text,
  vol_status   text,                    -- scorecard needs this
  logged_at    text,
  updated_at   timestamptz default now()
);
create index if not exists worklog_date      on public.worklog (date);
create index if not exists worklog_emp_date   on public.worklog (employee_id, date);
create index if not exists worklog_status     on public.worklog (status);
create index if not exists worklog_proj_date  on public.worklog (project, date);
alter table public.worklog add column if not exists vol_status text;  -- safe if table pre-existed

-- ── Attendance: one row per employee per day ───────────────────────────────────────────
create table if not exists public.attendance (
  id            text primary key,        -- = employee_id || '_' || date
  employee_id   text,
  date          date,
  shift         text,
  time_in       text,
  lunch_out     text,
  lunch_in      text,
  time_out      text,
  hours_worked  numeric,
  updated_at    timestamptz default now()
);
create index if not exists attendance_date on public.attendance (date);
create index if not exists attendance_emp   on public.attendance (employee_id);

-- ── Lock down worklog + attendance: RLS on, NO anon policies ───────────────────────────
alter table public.worklog    enable row level security;
alter table public.attendance enable row level security;

-- ── tracker_beat: append-only, anon INSERT only ───────────────────────────────────────
create table if not exists public.tracker_beat (
  id           bigint generated always as identity primary key,
  entry_id     text,
  employee_id  text,
  created_at   timestamptz default now()
);
create index if not exists tracker_beat_entry_time on public.tracker_beat (entry_id, created_at desc);
create index if not exists tracker_beat_created     on public.tracker_beat (created_at);

grant insert on public.tracker_beat to anon;
alter table public.tracker_beat enable row level security;

drop policy if exists tracker_beat_anon_insert on public.tracker_beat;
create policy tracker_beat_anon_insert on public.tracker_beat
  for insert to anon with check (true);

-- Done. Three tables ready (empty). Point aura-config.js SUPA_URL/SUPA_KEY at THIS project,
-- set the TEST backend's SUPA_URL + SUPA_SERVICE_KEY script properties, then run the
-- backfill from the TEST Apps Script to populate history from the copied Sheet.
