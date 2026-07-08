# Tasks — Daily Emo Detox

## Sprint 1 — DB + Emotion Grid (demo-first)
**Goal:** App loads with emotion icons and advice visible to any visitor.
- Create Supabase project; run migration SQL
- Seed 10 emotions + 2 advice rows each
- Build `/` page: emotion icon grid (loading / empty / ready states)
- Tap emotion → fetch advice → show advice card (no login required)
- Error state: advice fetch fails → show friendly retry message
- Write session row on every tap
**DoD:** Visitor taps any emotion and sees advice; `sessions` table gains a row; no login required.

## Sprint 2 — Tap Limit + Paywall Modal ✦ v1 functional milestone
**Goal:** Free cap enforced; Stripe Checkout live; subscription unlocks access.
- Fingerprint-based daily tap counter (server-side check)
- 4th tap returns `paywall: true` → UI opens paywall modal
- Paywall modal: email capture form → inserts `leads` row
- "Unlock Full Access" button → `/api/checkout` → Stripe Checkout session
- Stripe webhook `/api/webhooks/stripe` → upsert `subscriptions`
- Return URL detects active subscription → bypasses paywall
- All five UI states handled on paywall modal (loading, empty, error, partial, ready)
**DoD:** Full end-to-end scenario from PRD passes in a real browser with a real Stripe test payment.

## Sprint 3 — Admin View
**Goal:** Builder can see sessions, leads, subscriptions.
- `/admin` page (basic HTTP basic-auth or secret path)
- Sessions table: emotion, timestamp, paid/free
- Leads table: email, source, date
- Subscriptions table: status, plan, Stripe ID
**DoD:** All three tables render live data; counts match Supabase dashboard.

## Sprint 4 — Lock It Down (Auth + RLS)
**Goal:** Users own their data; anonymous demo still works for unauthenticated visitors.
- Supabase Auth (email/magic link)
- Sign-up / sign-in flow
- Replace v1 RLS policies with `auth.uid() = user_id` on sessions, leads, subscriptions
- Subscription status tied to authenticated user
- Paid badge shown in header when logged in + active
**DoD:** Two browser sessions — one anon (sees demo, hits paywall), one logged-in paid (no paywall). RLS confirmed in Supabase policy editor.

## Sprint 5 — AI Advice Enrichment
**Goal:** AI-generated alternatives stored alongside seed advice.
- OpenAI server route generates `ai_body` for each advice row
- Stores `ai_body`, `ai_body_source`, `ai_body_confidence`, `ai_body_review_status`
- Admin review queue: approve / reject AI suggestions
- Approved AI body replaces displayed advice
**DoD:** At least one emotion shows AI-approved advice; confidence + review_status visible in admin.

## Gantt (sprint → week)
| Sprint | Week |
|---|---|
| 1 — DB + Grid | 1 |
| 2 — Paywall + Stripe | 1 |
| 3 — Admin View | 2 |
| 4 — Lock It Down | 2 |
| 5 — AI Enrichment | 3+ |