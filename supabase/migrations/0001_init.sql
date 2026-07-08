create table if not exists emotions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  name text not null,
  icon text not null,
  color text not null,
  created_at timestamptz not null default now()
);
alter table emotions enable row level security;
drop policy if exists "emotions_v1_read" on emotions;
create policy "emotions_v1_read" on emotions for select using (true);
drop policy if exists "emotions_v1_write" on emotions;
create policy "emotions_v1_write" on emotions for all using (true) with check (true);

insert into emotions (id, name, icon, color) values
  ('11111111-0000-0000-0000-000000000001', 'Stressed',    '😤', '#FF6B6B'),
  ('11111111-0000-0000-0000-000000000002', 'Anxious',     '😰', '#FFA07A'),
  ('11111111-0000-0000-0000-000000000003', 'Overwhelmed', '😵', '#FFD700'),
  ('11111111-0000-0000-0000-000000000004', 'Sad',         '😢', '#6495ED'),
  ('11111111-0000-0000-0000-000000000005', 'Angry',       '😠', '#DC143C'),
  ('11111111-0000-0000-0000-000000000006', 'Burned Out',  '🥵', '#FF8C00'),
  ('11111111-0000-0000-0000-000000000007', 'Lonely',      '😔', '#9370DB'),
  ('11111111-0000-0000-0000-000000000008', 'Confused',    '😕', '#20B2AA')
on conflict (id) do nothing;

create table if not exists advice_cards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  emotion_id uuid references emotions(id),
  advice_text text not null,
  advice_source text not null default 'openai-gpt-4o',
  advice_confidence numeric,
  advice_review_status text not null default 'unreviewed',
  created_at timestamptz not null default now()
);
alter table advice_cards enable row level security;
drop policy if exists "advice_cards_v1_read" on advice_cards;
create policy "advice_cards_v1_read" on advice_cards for select using (true);
drop policy if exists "advice_cards_v1_write" on advice_cards;
create policy "advice_cards_v1_write" on advice_cards for all using (true) with check (true);

insert into advice_cards (emotion_id, advice_text, advice_source, advice_confidence, advice_review_status) values
  ('11111111-0000-0000-0000-000000000001', 'Take 5 slow breaths right now. Then write down the single most urgent task on paper and do only that one thing for the next 25 minutes. Stress shrinks when you shrink the target.', 'seed-human', 1.0, 'approved'),
  ('11111111-0000-0000-0000-000000000004', 'Sadness needs space, not suppression. Allow yourself 10 minutes to feel it fully, then step outside for a 5-minute walk — sunlight and movement gently shift your brain chemistry.', 'seed-human', 1.0, 'approved'),
  ('11111111-0000-0000-0000-000000000006', 'Burnout is a signal, not a failure. Block 30 minutes today — no screens, no output, just rest. Recovery is productive.', 'seed-human', 1.0, 'approved');

create table if not exists check_in_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  emotion_id uuid references emotions(id),
  advice_card_id uuid references advice_cards(id),
  session_token text,
  created_at timestamptz not null default now()
);
alter table check_in_sessions enable row level security;
drop policy if exists "check_in_sessions_v1_read" on check_in_sessions;
create policy "check_in_sessions_v1_read" on check_in_sessions for select using (true);
drop policy if exists "check_in_sessions_v1_write" on check_in_sessions;
create policy "check_in_sessions_v1_write" on check_in_sessions for all using (true) with check (true);

insert into check_in_sessions (emotion_id, advice_card_id, session_token) values
  ('11111111-0000-0000-0000-000000000001', (select id from advice_cards where emotion_id = '11111111-0000-0000-0000-000000000001' limit 1), 'demo-session-1'),
  ('11111111-0000-0000-0000-000000000004', (select id from advice_cards where emotion_id = '11111111-0000-0000-0000-000000000004' limit 1), 'demo-session-2'),
  ('11111111-0000-0000-0000-000000000006', (select id from advice_cards where emotion_id = '11111111-0000-0000-0000-000000000006' limit 1), 'demo-session-3');

create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  email text not null,
  subscription_status text not null default 'free',
  stripe_customer_id text,
  stripe_session_id text,
  paid_at timestamptz,
  created_at timestamptz not null default now()
);
alter table leads enable row level security;
drop policy if exists "leads_v1_read" on leads;
create policy "leads_v1_read" on leads for select using (true);
drop policy if exists "leads_v1_write" on leads;
create policy "leads_v1_write" on leads for all using (true) with check (true);

insert into leads (email, subscription_status, paid_at) values
  ('demo.user1@example.com', 'paid', now() - interval '3 days'),
  ('demo.user2@example.com', 'free', null),
  ('demo.user3@example.com', 'paid', now() - interval '1 day');

create table if not exists touchpoints (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  lead_id uuid references leads(id),
  event_type text not null,
  metadata jsonb,
  created_at timestamptz not null default now()
);
alter table touchpoints enable row level security;
drop policy if exists "touchpoints_v1_read" on touchpoints;
create policy "touchpoints_v1_read" on touchpoints for select using (true);
drop policy if exists "touchpoints_v1_write" on touchpoints;
create policy "touchpoints_v1_write" on touchpoints for all using (true) with check (true);

insert into touchpoints (lead_id, event_type, metadata) values
  ((select id from leads where email = 'demo.user1@example.com'), 'email_captured', '{"page": "home"}'),
  ((select id from leads where email = 'demo.user1@example.com'), 'payment_completed', '{"amount": 900, "currency": "usd"}'),
  ((select id from leads where email = 'demo.user2@example.com'), 'email_captured', '{"page": "home"}');

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  action text not null,
  entity_type text,
  entity_id uuid,
  risk_level text not null default 'low',
  metadata jsonb,
  created_at timestamptz not null default now()
);
alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);