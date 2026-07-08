# Tasks — Daily Emo Detox

## Sprint 1 — DB, Emotion Engine & Demo Page
**Goal:** Anonymous visitor can tap any emotion and see a real advice card from the database.

- [ ] Run migration SQL (emotions, advice_cards, leads, touchpoints, audit_logs)
- [ ] Seed 8 emotions + 8 advice cards with realistic copy
- [ ] Build `/` page: emotion icon grid (8 icons, coloured, labelled)
- [ ] Handle all states: loading skeleton, empty (no emotions found), error (DB unreachable), ready
- [ ] Tap emotion → query `advice_cards` by `emotion_id` → render advice card
- [ ] Advice card shows: headline, body, breathing exercise, affirmation
- [ ] Write `touchpoint` row on every tap (event: `emotion_tap`)
- [ ] Confirm seed rows are CRUD-able (not hardcoded in UI)

**Definition of Done:** Anonymous user taps Stressed → advice card renders with DB data → touchpoint row exists in Supabase table viewer.

---

## Sprint 2 — Lead Capture & Touchpoint Logging
**Goal:** Second tap gates on email; lead is stored with source emotion.

- [ ] Track tap count in session (not DB)
- [ ] Second tap → email capture modal (name optional, email required)
- [ ] Submit → POST `/api/leads` → insert `leads` row → insert `touchpoint` (event: `lead_captured`)
- [ ] Validate email server-side; return 400 on bad format
- [ ] Modal states: idle, submitting, success, error
- [ ] Empty state: if lead already exists for email, skip duplicate insert

**Definition of Done:** Submit email → `leads` row in DB with `source_emotion_id` set → `touchpoint` row with `lead_id` linked.

---

## Sprint 3 — Stripe Checkout & Paid Access Gate ✅ v1 FUNCTIONAL MILESTONE
**Goal:** Real payment unlocks unlimited advice; webhook updates DB.

- [ ] Add `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` to Vercel env
- [ ] `/api/checkout` — create Stripe Checkout session (price hard-coded v1), return URL
- [ ] `/api/webhook` — verify signature → set `leads.paid_at`, `plan = 'paid'` → write audit_log
- [ ] Gate: unpaid leads see modal after tap 1; paid leads see all cards freely
- [ ] `/success` page — confirms payment, shows next emotion invite
- [ ] `/cancel` page — friendly message, retry CTA
- [ ] Test with Stripe test card `4242 4242 4242 4242`

**Definition of Done:** Test card charged → `leads.paid_at` set in DB → full advice card visible without modal → audit_log row with `action = 'payment_success'`.

---

## Sprint 4 — Auth & Per-User Lock-Down
**Goal:** Users have accounts; their data is isolated.

- [ ] Enable Supabase Auth (email/password)
- [ ] `/signup` and `/login` pages
- [ ] On sign-in, link existing `leads` row to `auth.uid()` via `user_id`
- [ ] Replace all v1 permissive RLS policies with `auth.uid() = user_id`
- [ ] Paid gate reads from authenticated session + `leads` table
- [ ] Test: two accounts cannot read each other's touchpoints

**Definition of Done:** User A and User B see only their own data after login; unauthenticated DB query returns 0 rows on protected tables.

---

## Sprint 5 — Admin Dashboard & AI Advice
**Goal:** Builder can see leads and manage AI-generated advice.

- [ ] `/admin` page (route-guarded to builder email)
- [ ] Leads table: email, emotion, paid status, touchpoint count, created_at
- [ ] Touchpoints feed: chronological event list
- [ ] AI draft: call OpenAI per emotion → insert advice_card with `body_review_status = 'unreviewed'`
- [ ] Admin approve / reject draft → set `body_review_status`
- [ ] Only `approved` cards shown to visitors
- [ ] Audit log viewer

**Definition of Done:** Admin approves AI draft → card live for visitors. Rejected draft never appears. Audit log shows every approval action.

---

## Gantt (Sprint → Feature)
```
Sprint 1:  Emotion grid, advice card, touchpoint logging
Sprint 2:  Email capture, lead creation, session tap gate
Sprint 3:  Stripe checkout, webhook, paid gate          ← v1 FUNCTIONAL
Sprint 4:  Auth, login, RLS lock-down
Sprint 5:  Admin dashboard, AI advice drafts
```
