# Architecture — Daily Emo Detox

## Stack
| Layer | Choice |
|---|---|
| Frontend | Next.js 14 (App Router) on Vercel |
| Database | Supabase (Postgres + RLS) |
| Auth | Supabase Auth (added in lock-down sprint) |
| Payments | Stripe Checkout + Webhooks |
| AI (later) | OpenAI via server-side route only |

## Build Sequence
**Now:** Emotion grid → tap → advice → session write → paywall → Stripe → unlock
**Next:** Auth, per-user session history, lead nurture emails
**Later:** AI-generated personalised advice, mood trend dashboard

## Key User Action — Step-by-Step
1. Visitor opens homepage; emotion grid loads from `emotions` table (seeded).
2. User taps an emotion icon → client posts to `/api/sessions` → row written to `sessions`.
3. Server checks today's tap count for this browser fingerprint/user.
4. If under limit → fetch matching advice row → return to UI → display card.
5. If at limit → return `paywall: true` → UI opens paywall modal → lead email captured to `leads`.
6. User clicks Pay → server creates Stripe Checkout session → redirect.
7. Stripe webhook hits `/api/webhooks/stripe` → `subscriptions` row upserted → user flagged as paid.
8. User returns, tap limit lifted, advice flows freely.

## Why It Runs Without AI
All advice rows are seeded static text. AI enrichment (Sprint 5+) only adds an alternative `advice` value alongside the original — the rule-based path always wins if AI is off.