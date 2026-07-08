# Tasks — Daily Emo Detox

---

## Sprint 1 — Data Foundation & Emotion Picker (Demo-First)
**Goal:** App renders emotion grid with seeded advice; tapping an emotion shows an advice card. No login required.

- [ ] Run migration SQL (emotions, advice, sessions, leads, subscriptions, audit_logs tables + seed data)
- [ ] Build `/` page: emotion grid from `emotions` table — loading / empty / error / ready states
- [ ] Tap emotion → fetch best advice row for that emotion → render advice card
- [ ] Insert session row on every advice display (visitor_token from localStorage)
- [ ] Handle empty state: emotion has no advice → show friendly fallback copy
- [ ] All screens render correctly in Vercel preview without login

**Definition of Done:** Open the app URL, tap any emotion, read advice, confirm session row exists in Supabase — without signing in.

---

## Sprint 2 — Paywall, Email Capture & Stripe Checkout ✦ v1 functional milestone
**Goal:** Free session limit enforced; email captured; Stripe Checkout live; Pro upgrade confirmed.

- [ ] Track session count via visitor_token; show paywall modal after 3rd free session
- [ ] Email capture form in paywall modal → upsert `leads` row (touchpoint = 'paywall-modal')
- [ ] "Go Pro" button → POST to `/api/checkout` Edge Function → redirect to Stripe Checkout
- [ ] Stripe webhook handler → update `subscriptions` row to plan='pro', status='active'
- [ ] Pro users: session limit lifted (check subscriptions by email or visitor_token)
- [ ] Success page after Stripe redirect: "You're Pro — enjoy unlimited sessions"
- [ ] All Stripe keys in env vars; no secrets in client code
- [ ] Log checkout_started and subscription_activated to audit_logs

**Definition of Done:** Complete the full scenario — tap emotion, hit paywall, enter email, pay in Stripe test mode, land on success page, confirm subscriptions row updated and audit_log entry written.

---

## Sprint 3 — AI Advice Fallback & Admin Review Queue
**Goal:** OpenAI generates advice when DB has no entry; builder can review and approve AI-generated rows.

- [ ] Edge Function `generate_advice(emotion_id)`: call OpenAI, store body + source + confidence + review_status='unreviewed'
- [ ] Fallback: if advice table has no row for emotion → call generate_advice → return result
- [ ] Admin route `/admin/advice` — list advice rows, filter by review_status
- [ ] Approve / flag buttons update review_status in DB (no dead buttons)
- [ ] Confidence < 0.7 → auto-set review_status = 'needs_review'
- [ ] Log every generate_advice call to audit_logs

**Definition of Done:** Tap an emotion with no seeded advice → AI card appears → builder opens /admin/advice → approves it → review_status updated in DB.

---

## Sprint 4 — Auth & Lock It Down
**Goal:** Users sign up / log in; sessions and subscriptions scoped to their account; RLS owner policies live.

- [ ] Enable Supabase Auth (email/password)
- [ ] Sign-up / log-in pages; redirect after auth
- [ ] Migrate visitor_token sessions to user_id on sign-up
- [ ] Replace v1 permissive RLS policies with `auth.uid() = user_id` on all tables
- [ ] Pro user session history page (own sessions only)
- [ ] Test: user A cannot read user B's sessions or subscription

**Definition of Done:** Two test accounts; each sees only their own data; permissive policies confirmed removed.

---

## Gantt (sprint → feature)
```
Sprint 1 | Emotion grid, advice card, session logging (no login)
Sprint 2 | Paywall, email lead, Stripe checkout, Pro unlock  ← v1 functional
Sprint 3 | AI advice fallback, admin review queue
Sprint 4 | Auth, per-user RLS, session history
```
