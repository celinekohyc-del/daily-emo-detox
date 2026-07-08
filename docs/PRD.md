# PRD — Daily Emo Detox

## Problem
People hit emotional walls — stress, anxiety, anger, overwhelm — and have no quick, structured way to decompress. Generic wellness apps are too broad. They need a one-tap tool that gives them a concrete path back to calm.

## Target Users
Employees, business owners, homemakers — anyone who feels emotionally overloaded and wants a 5-minute reset, not a therapy session.

## Core Objects
| Object | Purpose |
|---|---|
| `emotion` | One of 8 named feelings with an icon and colour |
| `advice_card` | Structured coping content tied to an emotion |
| `lead` | Visitor email + payment status |
| `touchpoint` | Every emotion tap and advice view |
| `audit_log` | Record of every meaningful system action |

## MVP Must-Haves
- [ ] Homepage shows 8 emotion icons — no login required
- [ ] Tap an emotion → see a full advice card (headline, body, breathing exercise, affirmation)
- [ ] First tap is free; second tap triggers email capture
- [ ] Email capture creates a `lead` row
- [ ] Stripe checkout unlocks unlimited advice
- [ ] Webhook marks `lead.paid_at` and `plan = 'paid'`
- [ ] Every tap logged as a `touchpoint`
- [ ] All buttons persist to DB; no dead UI

## Non-Goals (v1)
- User accounts / login
- Mood history / calendar
- Push notifications
- Admin dashboard
- Multi-language support

## Success Criteria
A real visitor lands on the homepage, taps **Stressed**, reads the advice card, enters their email, clicks **Unlock Full Access**, completes Stripe checkout with a test card, and immediately sees the full advice card without any error — and `leads.paid_at` is set in the database.
