# PRD — Daily Emo Detox

## Problem
People hit emotional walls—stress, anxiety, anger, overwhelm—and have no quick, private way to get grounded again. They need a one-tap micro-tool, not a therapy session.

## Target Users
Employees, business owners, homemakers, and anyone who feels daily stress and wants fast, actionable relief.

## Core Objects
- **Emotion** — icon, label, category
- **Advice** — text body, emotion_id, tier (free/paid)
- **Session** — user taps an emotion; session records the emotion chosen and advice served
- **Lead** — email captured before checkout
- **Subscription** — Stripe checkout result tied to a user

## MVP Must-Haves
- [ ] Emotion icon grid renders (8–12 emotions) without login
- [ ] Tapping an emotion shows one piece of advice instantly
- [ ] Free tier: 3 emotion taps per day; 4th tap triggers paywall modal
- [ ] Paywall modal shows price + Stripe Checkout button
- [ ] Stripe Checkout completes and unlocks unlimited access
- [ ] Session is written to the database on every tap
- [ ] Lead email captured on paywall open
- [ ] Admin can view sessions and leads list

## Non-Goals (v1)
- Personalised AI-generated advice (rule-based text only in v1)
- Mobile app / push notifications
- Social sharing, streaks, gamification
- Multi-language support
- Team / organisation accounts

## Success Criterion
A first-time visitor lands on the app, taps an emotion, reads advice, hits the tap limit, enters their email, completes Stripe Checkout, and immediately sees unlimited advice — all in one browser session, with the session and subscription rows visible in Supabase.