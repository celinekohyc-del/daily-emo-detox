create table if not exists emotions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  name text not null,
  icon_emoji text not null,
  color_hex text not null default '#6366f1',
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists advice_cards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  emotion_id uuid references emotions(id),
  headline text not null,
  body text not null,
  body_source text not null default 'seed',
  body_confidence numeric not null default 1.0,
  body_review_status text not null default 'approved',
  breathing_exercise text,
  affirmation text,
  is_premium boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  email text not null,
  name text,
  source_emotion_id uuid references emotions(id),
  stripe_session_id text,
  stripe_customer_id text,
  paid_at timestamptz,
  plan text default 'free',
  created_at timestamptz not null default now()
);

create table if not exists touchpoints (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  lead_id uuid references leads(id),
  event_type text not null,
  emotion_id uuid references emotions(id),
  advice_card_id uuid references advice_cards(id),
  metadata jsonb,
  created_at timestamptz not null default now()
);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  actor text not null default 'system',
  action text not null,
  target_table text,
  target_id uuid,
  payload jsonb,
  risk_level text not null default 'low',
  created_at timestamptz not null default now()
);

alter table emotions enable row level security;
drop policy if exists "emotions_v1_read" on emotions;
create policy "emotions_v1_read" on emotions for select using (true);
drop policy if exists "emotions_v1_write" on emotions;
create policy "emotions_v1_write" on emotions for all using (true) with check (true);

alter table advice_cards enable row level security;
drop policy if exists "advice_cards_v1_read" on advice_cards;
create policy "advice_cards_v1_read" on advice_cards for select using (true);
drop policy if exists "advice_cards_v1_write" on advice_cards;
create policy "advice_cards_v1_write" on advice_cards for all using (true) with check (true);

alter table leads enable row level security;
drop policy if exists "leads_v1_read" on leads;
create policy "leads_v1_read" on leads for select using (true);
drop policy if exists "leads_v1_write" on leads;
create policy "leads_v1_write" on leads for all using (true) with check (true);

alter table touchpoints enable row level security;
drop policy if exists "touchpoints_v1_read" on touchpoints;
create policy "touchpoints_v1_read" on touchpoints for select using (true);
drop policy if exists "touchpoints_v1_write" on touchpoints;
create policy "touchpoints_v1_write" on touchpoints for all using (true) with check (true);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into emotions (id, name, icon_emoji, color_hex, display_order) values
  ('a1000000-0000-0000-0000-000000000001', 'Stressed',   '😫', '#ef4444', 1),
  ('a1000000-0000-0000-0000-000000000002', 'Anxious',    '😰', '#f97316', 2),
  ('a1000000-0000-0000-0000-000000000003', 'Angry',      '😡', '#dc2626', 3),
  ('a1000000-0000-0000-0000-000000000004', 'Sad',        '😢', '#3b82f6', 4),
  ('a1000000-0000-0000-0000-000000000005', 'Overwhelmed','🤯', '#8b5cf6', 5),
  ('a1000000-0000-0000-0000-000000000006', 'Exhausted',  '😴', '#64748b', 6),
  ('a1000000-0000-0000-0000-000000000007', 'Lonely',     '🥺', '#06b6d4', 7),
  ('a1000000-0000-0000-0000-000000000008', 'Hopeless',   '😞', '#6b7280', 8)
on conflict (id) do nothing;

insert into advice_cards (id, emotion_id, headline, body, breathing_exercise, affirmation, body_source, body_confidence, body_review_status, is_premium) values
  ('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   'Release the pressure valve',
   'Step away for 5 minutes. Write down the top 3 things causing stress, then ask: which one actually matters today? Tackle only that one.',
   'Breathe in for 4 counts, hold for 4, out for 6. Repeat 5 times.',
   'I can only do one thing at a time, and that is enough.',
   'seed', 1.0, 'approved', false),
  ('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000002',
   'Ground yourself right now',
   'Name 5 things you can see, 4 you can touch, 3 you can hear. Anxiety lives in the future — this pulls you back to now.',
   'Breathe in for 5 counts, breathe out for 7. Slow the exhale.',
   'Right now, in this moment, I am safe.',
   'seed', 1.0, 'approved', false),
  ('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000003',
   'Discharge the charge',
   'Anger is energy. Do 20 jumping jacks or walk briskly for 3 minutes before responding to anything. Physical release clears mental fog.',
   'Breathe in sharply through the nose, exhale forcefully through the mouth. Repeat 10 times.',
   'I choose my response. My response is my power.',
   'seed', 1.0, 'approved', false),
  ('b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000004',
   'Let it move through you',
   'Sadness needs expression, not suppression. Allow 10 minutes to feel it fully — journal, cry, or sit quietly. Then do one tiny kind act for yourself.',
   'Breathe slowly and deeply, placing one hand on your chest. Feel each breath.',
   'My feelings are valid. They are passing through, not staying forever.',
   'seed', 1.0, 'approved', false),
  ('b1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000005',
   'Shrink the pile',
   'Write every task on paper. Cross out anything not due today. Pick ONE item and start a 10-minute timer. Progress over perfection.',
   'Box breathe: in 4, hold 4, out 4, hold 4. Repeat 4 times.',
   'I do not have to do everything. I only have to do the next thing.',
   'seed', 1.0, 'approved', false),
  ('b1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000006',
   'Restore before you resume',
   'Exhaustion is a signal, not a weakness. Drink a full glass of water. Close your eyes for 5 minutes. Your output doubles when you refuel first.',
   'Breathe in deeply, hold for 2, release fully with a sigh. Repeat 6 times.',
   'Rest is productive. I am allowed to pause.',
   'seed', 1.0, 'approved', false),
  ('b1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000007',
   'Reach one inch further',
   'Send one genuine message to someone you trust — even just "thinking of you". Connection does not require a long conversation.',
   'Breathe in warmth, breathe out tension. Visualise someone who cares for you.',
   'I am worthy of connection and I take one small step toward it.',
   'seed', 1.0, 'approved', false),
  ('b1000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000008',
   'Find the next small light',
   'Hopelessness narrows vision. List 3 things that have changed for the better in the past year — even tiny ones. Hope is rebuilt one evidence point at a time.',
   'Breathe in for 4, breathe out slowly for 8. Let the long exhale calm your nervous system.',
   'This feeling is temporary. I have overcome hard things before.',
   'seed', 1.0, 'approved', false)
on conflict (id) do nothing;