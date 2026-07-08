create table if not exists emotions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  label text not null,
  icon_url text not null,
  category text not null,
  sort_order int not null default 0
);

alter table emotions enable row level security;
drop policy if exists "emotions_v1_read" on emotions;
create policy "emotions_v1_read" on emotions for select using (true);
drop policy if exists "emotions_v1_write" on emotions;
create policy "emotions_v1_write" on emotions for all using (true) with check (true);

create table if not exists advice (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  emotion_id uuid not null,
  body text not null,
  body_source text not null default 'human',
  body_confidence numeric not null default 1.0,
  body_review_status text not null default 'unreviewed'
);

alter table advice enable row level security;
drop policy if exists "advice_v1_read" on advice;
create policy "advice_v1_read" on advice for select using (true);
drop policy if exists "advice_v1_write" on advice;
create policy "advice_v1_write" on advice for all using (true) with check (true);

create table if not exists sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  emotion_id uuid not null,
  advice_id uuid not null,
  visitor_token text
);

alter table sessions enable row level security;
drop policy if exists "sessions_v1_read" on sessions;
create policy "sessions_v1_read" on sessions for select using (true);
drop policy if exists "sessions_v1_write" on sessions;
create policy "sessions_v1_write" on sessions for all using (true) with check (true);

create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  email text unique not null,
  touchpoint text not null default 'paywall-modal',
  converted boolean not null default false
);

alter table leads enable row level security;
drop policy if exists "leads_v1_read" on leads;
create policy "leads_v1_read" on leads for select using (true);
drop policy if exists "leads_v1_write" on leads;
create policy "leads_v1_write" on leads for all using (true) with check (true);

create table if not exists subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  email text not null,
  plan text not null default 'free',
  stripe_customer_id text,
  stripe_subscription_id text,
  status text not null default 'active'
);

alter table subscriptions enable row level security;
drop policy if exists "subscriptions_v1_read" on subscriptions;
create policy "subscriptions_v1_read" on subscriptions for select using (true);
drop policy if exists "subscriptions_v1_write" on subscriptions;
create policy "subscriptions_v1_write" on subscriptions for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  actor_id text,
  actor_type text not null default 'system',
  table_name text not null,
  row_id uuid,
  action text not null,
  payload_json jsonb
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into emotions (id, label, icon_url, category, sort_order) values
  ('a1000000-0000-0000-0000-000000000001', 'Stressed', '😤', 'stress', 1),
  ('a1000000-0000-0000-0000-000000000002', 'Anxious', '😰', 'anxiety', 2),
  ('a1000000-0000-0000-0000-000000000003', 'Angry', '😠', 'anger', 3),
  ('a1000000-0000-0000-0000-000000000004', 'Sad', '😢', 'sadness', 4),
  ('a1000000-0000-0000-0000-000000000005', 'Overwhelmed', '😵', 'overwhelm', 5),
  ('a1000000-0000-0000-0000-000000000006', 'Burned Out', '🥵', 'stress', 6),
  ('a1000000-0000-0000-0000-000000000007', 'Lonely', '😔', 'sadness', 7),
  ('a1000000-0000-0000-0000-000000000008', 'Frustrated', '😤', 'anger', 8)
on conflict do nothing;

insert into advice (emotion_id, body, body_source, body_confidence, body_review_status) values
  ('a1000000-0000-0000-0000-000000000001', 'Step away from your screen for 5 minutes. Inhale for 4 counts, hold for 4, exhale for 6. Stress hormones drop within two minutes of controlled breathing. Write down the ONE thing causing the most tension and set it aside until you are calm.', 'human', 1.0, 'approved'),
  ('a1000000-0000-0000-0000-000000000002', 'Ground yourself with the 5-4-3-2-1 method: name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, 1 you can taste. Anxiety lives in the future — this pulls you into the present moment instantly.', 'human', 1.0, 'approved'),
  ('a1000000-0000-0000-0000-000000000003', 'Before you react, press your feet firmly into the floor and breathe slowly three times. Anger is energy — redirect it by writing exactly what bothered you in one sentence, then crumple the paper and bin it. Physical release, then clarity.', 'human', 1.0, 'approved'),
  ('a1000000-0000-0000-0000-000000000004', 'Allow the sadness without judgment — it is information, not weakness. Text one person you trust, not to vent, just to say "thinking of you." Connection is the fastest antidote. Then do one small act of care for yourself: water, a walk, a warm drink.', 'human', 1.0, 'approved'),
  ('a1000000-0000-0000-0000-000000000005', 'Stop adding to the list. Pick just three tasks for today and hide the rest. Overwhelm is a signal your brain has too many open loops — close them by writing everything down, then choose only three. Progress beats perfection every time.', 'human', 1.0, 'approved'),
  ('a1000000-0000-0000-0000-000000000006', 'Burnout is your body enforcing a boundary your mind refused to set. Identify one commitment you can defer or delegate today — not next week. Rest is not a reward; it is the work that makes all other work possible.', 'human', 1.0, 'approved')
on conflict do nothing;