# Architecture — Daily Emo Detox

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Backend/DB:** Supabase (Postgres + Auth + Edge Functions)
- **Payments:** Stripe Checkout + Webhooks
- **AI:** OpenAI via Supabase Edge Function (server-side only)

## Now vs Later
**Now:** Emotion picker → advice card → email capture → Stripe checkout → session log 
**Later:** Auth + per-user history, AI advice regeneration, admin dashboard, usage analytics

## Key User Action — Step by Step
1. Visitor opens `/` — emotion grid renders from `emotions` table (seeded)
2. User taps an emotion icon → client POST to `/api/session`
3. Edge Function queries `advice` table for that emotion; falls back to OpenAI if none found
4. Advice card rendered; session row inserted into `sessions`
5. After 3rd free session, paywall modal appears; user enters email → `leads` row upserted
6. User clicks "Go Pro" → server creates Stripe Checkout session → redirect
7. Stripe webhook fires → `subscriptions` row updated to `pro`
8. User returns to app; session limit lifted

## Layer Plan
1. **Data first** — all tables + seed advice rows
2. **App logic** — session counting, paywall gate, Stripe flow
3. **Smart features** — AI fallback advice, confidence scoring, admin review queue

## Core Without AI
All seeded advice rows serve without any OpenAI call. AI is an enhancement, not a dependency.
