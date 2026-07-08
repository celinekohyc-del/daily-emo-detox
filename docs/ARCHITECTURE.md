# Architecture

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Database + Auth:** Supabase (Postgres + Row-Level Security)
- **Payments:** Stripe Checkout + Webhooks
- **AI:** OpenAI GPT-4o via a Next.js server-side API route

## What Is Built Now vs Later
**Now:** emotion grid → advice generation → email capture → Stripe payment — all without login.
**Later:** per-user auth, personal history, admin dashboard, email drips.

## Key User Action — Step-by-Step
1. Visitor taps an emotion icon on the homepage.
2. Next.js API route `/api/advice` receives `emotion_id`.
3. Server calls OpenAI, stores result in `advice_cards` (with source, confidence, review_status).
4. New row in `check_in_sessions` links emotion → advice card → anonymous session token.
5. Frontend receives advice text; teaser shown immediately.
6. Email capture modal appears; lead row inserted into `leads`.
7. User clicks "Unlock Full Access" → server creates Stripe Checkout session (price from env var, never in client).
8. On payment success, Stripe webhook fires → server updates `leads.subscription_status = paid`, logs to `audit_logs`.
9. Confirmation page renders; full advice card displayed.

## Layer Plan
1. **Data layer first** — tables, constraints, RLS policies, seed data.
2. **App logic** — API routes, CRUD, Stripe webhook; core runs with AI disabled (fallback to seeded advice).
3. **Intelligence on top** — OpenAI advice generation, confidence scoring, review queue.

## AI-Off Fallback
If the OpenAI call fails, the API route returns the highest-confidence seeded advice card for that emotion. The core flow never breaks.
