# Architecture — Daily Emo Detox

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Database + Auth:** Supabase (Postgres + RLS)
- **Payments:** Stripe Checkout + Webhooks
- **AI (later):** OpenAI via server-side route only

## What Gets Built Now vs Later
**Now:** emotion grid → advice card → email capture → Stripe checkout → paid access gate 
**Later:** user auth, mood history, AI-personalised advice, admin dashboard, reminders

## Key User Action — Step by Step
1. Visitor loads `/` — Supabase returns `emotions` rows — grid renders
2. Visitor taps an emotion icon — client queries `advice_cards` by `emotion_id`
3. `touchpoint` row written (event: `emotion_tap`)
4. First tap: full card shown. Second tap: email capture modal shown
5. Email submitted → `leads` row created → `touchpoint` row written (event: `lead_captured`)
6. Visitor clicks **Unlock** → `/api/checkout` creates Stripe session → redirect
7. Stripe webhook hits `/api/webhook` → `leads.paid_at` set, `plan = 'paid'` → audit log written
8. Visitor redirected to `/success` → paid gate removed → full advice visible

## Layer Plan
1. **Data first:** tables + seed data + RLS policies
2. **App logic:** fetch, gate, and write — all server-side routes; no secrets in the browser
3. **Smart features later:** AI advice generation with approval flow

## Core Without AI
All 8 advice cards are hand-written seed data. Removing the AI layer leaves a fully functional, chargeable product.
