create table if not exists emotions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  label text not null,
  icon_emoji text not null,
  category text not null default 'general',
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

alter table emotions enable row level security;
drop policy if exists "emotions_v1_read" on emotions;
create policy "emotions_v1_read" on emotions for select using (true);
drop policy if exists "emotions_v1_write" on emotions;
create policy "emotions_v1_write" on emotions for all using (true) with check (true);

create table if not exists advice (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  emotion_id uuid references emotions(id),
  body text not null,
  tier text not null default 'free',
  ai_body text,
  ai_body_source text,
  ai_body_confidence numeric,
  ai_body_review_status text default 'unreviewed',
  created_at timestamptz not null default now()
);

alter table advice enable row level security;
drop policy if exists "advice_v1_read" on advice;
create policy "advice_v1_read" on advice for select using (true);
drop policy if exists "advice_v1_write" on advice;
create policy "advice_v1_write" on advice for all using (true) with check (true);

create table if not exists sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  emotion_id uuid references emotions(id),
  advice_id uuid references advice(id),
  fingerprint text,
  created_at timestamptz not null default now()
);

alter table sessions enable row level security;
drop policy if exists "sessions_v1_read" on sessions;
create policy "sessions_v1_read" on sessions for select using (true);
drop policy if exists "sessions_v1_write" on sessions;
create policy "sessions_v1_write" on sessions for all using (true) with check (true);

create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  email text not null,
  source text not null default 'paywall_modal',
  created_at timestamptz not null default now()
);

alter table leads enable row level security;
drop policy if exists "leads_v1_read" on leads;
create policy "leads_v1_read" on leads for select using (true);
drop policy if exists "leads_v1_write" on leads;
create policy "leads_v1_write" on leads for all using (true) with check (true);

create table if not exists subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  stripe_customer_id text,
  stripe_subscription_id text,
  status text not null default 'active',
  plan text not null default 'monthly',
  created_at timestamptz not null default now()
);

alter table subscriptions enable row level security;
drop policy if exists "subscriptions_v1_read" on subscriptions;
create policy "subscriptions_v1_read" on subscriptions for select using (true);
drop policy if exists "subscriptions_v1_write" on subscriptions;
create policy "subscriptions_v1_write" on subscriptions for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  actor_type text not null,
  actor_id text,
  action text not null,
  target_table text,
  target_id uuid,
  payload_snapshot jsonb,
  risk_level text,
  created_at timestamptz not null default now()
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into emotions (id, label, icon_emoji, category, sort_order) values
  ('a1000000-0000-0000-0000-000000000001', 'Stressed', '😤', 'work', 1),
  ('a1000000-0000-0000-0000-000000000002', 'Anxious', '😰', 'general', 2),
  ('a1000000-0000-0000-0000-000000000003', 'Overwhelmed', '🤯', 'work', 3),
  ('a1000000-0000-0000-0000-000000000004', 'Angry', '😡', 'social', 4),
  ('a1000000-0000-0000-0000-000000000005', 'Sad', '😢', 'general', 5),
  ('a1000000-0000-0000-0000-000000000006', 'Exhausted', '😴', 'home', 6),
  ('a1000000-0000-0000-0000-000000000007', 'Lonely', '🥺', 'social', 7),
  ('a1000000-0000-0000-0000-000000000008', 'Frustrated', '😒', 'work', 8),
  ('a1000000-0000-0000-0000-000000000009', 'Burnt Out', '🔥', 'work', 9),
  ('a1000000-0000-0000-0000-000000000010', 'Worried', '😟', 'general', 10)
on conflict (id) do nothing;

insert into advice (id, emotion_id, body, tier) values
  ('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'Take 5 slow breaths — inhale for 4 counts, hold for 4, exhale for 6. Your nervous system will shift within 90 seconds.', 'free'),
  ('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'Write down the one task causing the most stress. Break it into the next single physical action. Do only that.', 'paid'),
  ('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000002', 'Name what you are feeling out loud: "I am anxious." Labelling an emotion reduces its intensity in seconds.', 'free'),
  ('b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000002', 'Ask yourself: is there something I can act on right now? If yes, do one small thing. If no, give yourself permission to let it go for 10 minutes.', 'paid'),
  ('b1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000003', 'Pick the ONE most important thing on your plate. Everything else is noise for the next 25 minutes.', 'free'),
  ('b1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000004', 'Before you react, pause and count to 10. Anger peaks in seconds and drops fast — let the wave pass before responding.', 'free'),
  ('b1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000005', 'It is okay to feel this. Allow the sadness without judging it. Place one hand on your chest and take three gentle breaths.', 'free'),
  ('b1000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000006', 'Rest is not laziness — it is recovery. If you can, step away for 10 minutes. Drink water. Close your eyes. You have permission.', 'free')
on conflict (id) do nothing;