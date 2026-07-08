# Tasks & Sprints

## Sprint 1 — DB, Emotion Grid & Advice Engine
**Goal:** Core engine works end-to-end, demoable without login.

- [ ] Run migration SQL (all tables, seed data, v1 RLS policies)
- [ ] Build homepage `/` with 8 emotion icon cards (from `emotions` table)
- [ ] Implement all five states: loading skeleton, empty (no emotions in DB), partial (advice loading), error toast (AI failed), ready (advice card shown)
- [ ] Build `/api/advice` POST route: receive `emotion_id`, call OpenAI, store `advice_cards` row, store `check_in_sessions` row, return advice text
- [ ] AI fallback: if OpenAI fails, return highest-confidence approved card for that emotion
- [ ] Write `audit_log` row on every advice generation
- [ ] Verify seeded advice cards render on page load without any user action

**Definition of Done:** Visiting `/` shows 8 emotion icons. Clicking "Stressed" produces a coping advice card within 5 seconds. The `advice_cards` table gains a new row. The `check_in_sessions` table gains a new row. If OpenAI is disabled, a seeded card is served instead. No dead buttons.

---

## Sprint 2 — Lead Capture & Stripe Payment ✅ v1 functional milestone
**Goal:** App can capture an email and take a real payment.

- [ ] Email capture modal: appears after emotion tap, before full advice revealed
- [ ] `POST /api/leads` — insert lead row, insert `email_captured` touchpoint
- [ ] "Unlock Full Access" CTA on advice card (disabled for paid leads, active for free)
- [ ] `POST /api/checkout` — create Stripe Checkout session server-side, return URL
- [ ] Stripe webhook `POST /api/webhook/stripe` — verify signature, update `leads.subscription_status = paid`, set `paid_at`, log `payment_completed` touchpoint + audit log
- [ ] Payment confirmation page `/success` with clear copy
- [ ] Test with Stripe test card end-to-end
- [ ] Error state: Stripe failure shows user-friendly message, no DB mutation

**Definition of Done:** A visitor taps Stressed → enters email → clicks Unlock → completes Stripe test checkout → lands on `/success` → `leads` row shows `subscription_status = paid` and a `paid_at` timestamp. The Stripe dashboard shows the test payment. Total flow under 3 minutes.

---

## Sprint 3 — Auth & Lock-Down
**Goal:** Per-user data isolation; paid access enforced server-side.

- [ ] Enable Supabase Auth (magic-link email)
- [ ] Sign-up / login page `/login`
- [ ] On login, match `leads.email` to auth user, set `user_id` on existing rows
- [ ] Replace v1 permissive RLS with owner-scoped policies (`auth.uid() = user_id`)
- [ ] Personal check-in history page `/history` (auth-gated)
- [ ] Server-side middleware: paid content checks `leads.subscription_status` from session, not client state
- [ ] Confirm anonymous demo rows remain intact (seed data unaffected)

**Definition of Done:** Logging in as a paid user shows personal history. Logging in as a free user cannot access paid advice. RLS blocks cross-user reads. Seed demo data still renders for anonymous visitors.

---

## Sprint 4 — Admin, Touchpoints & Review Queue
**Goal:** Builder can see leads, conversions, and manage AI advice quality.

- [ ] Admin route `/admin` (service-role only, env-gated)
- [ ] Leads table: email, status, paid_at, check-in count
- [ ] Touchpoints timeline per lead
- [ ] Advice review queue: cards with `review_status = unreviewed` and confidence < 0.85
- [ ] Approve / reject buttons update `advice_review_status` + audit log (medium risk — confirm before write)
- [ ] Top-5 emotions tapped (count from `check_in_sessions`)
- [ ] Conversion rate: paid / total leads

**Definition of Done:** Admin page loads with real data. Approving a flagged advice card updates the DB and the row disappears from the queue. All actions logged in `audit_logs`.

---

## Gantt (sprint → week)
| Week | Sprint |
|---|---|
| 1 | Sprint 1 — DB + Emotion Grid + Advice Engine |
| 1–2 | Sprint 2 — Lead Capture + Stripe (v1 functional) |
| 2 | Sprint 3 — Auth + Lock-Down |
| 3 | Sprint 4 — Admin + Review Queue |
