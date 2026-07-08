# PRD — Daily Emo Detox

## Problem
People hit moments of stress, anger, or sadness and have no quick, private outlet. Generic wellness apps are bloated; therapy is expensive. A one-tap emotion-to-advice tool fills the gap in under 60 seconds.

## Target Users
Employees, business owners, stay-at-home parents — anyone who feels emotional friction during the day and wants a private, instant reset.

## Core Objects
- **Emotion** — icon, label, category (stress / anger / sadness / anxiety / overwhelm)
- **Session** — selected emotion, advice returned, timestamp, user_id
- **Advice** — emotion_id, body text, source, AI confidence, review_status
- **Lead** — email, touchpoint, converted flag
- **Subscription** — user_id, plan (free/pro), stripe_customer_id, status

## MVP Must-Haves
- [ ] Emotion picker grid (8–10 icons) visible without login
- [ ] Tap emotion → display tailored coping advice card
- [ ] Advice served from DB (AI-seeded, human-reviewable)
- [ ] Free tier: 3 sessions/day; Pro tier: unlimited
- [ ] Stripe Checkout for Pro upgrade (one-time or monthly)
- [ ] Email capture (lead) before first session
- [ ] Session history visible to logged-in Pro users
- [ ] Supabase Auth (email/password) in lock-down sprint

## Non-Goals (v1)
- Mobile app / PWA push notifications
- Community or social features
- Therapist matching
- Custom emotion uploads

## Definition of Done
A first-time visitor lands on the app, picks an emotion, reads real advice, enters their email, hits the Stripe Checkout for Pro, completes payment, and sees the "You're Pro" confirmation — all data persists in the database and is visible in the admin view.
