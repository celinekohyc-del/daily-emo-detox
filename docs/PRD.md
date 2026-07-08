# Daily Emo Detox — Product Requirements

## Problem
Stress, anxiety, and emotional overwhelm are daily realities for employees, business owners, and caregivers. There is no fast, focused tool that turns an emotion into a concrete, calming action in under 60 seconds.

## Target User
Anyone feeling emotionally overloaded: employees, business owners, housewives, students — anyone who needs a quick reset without a therapist.

## Core Objects
| Object | Purpose |
|---|---|
| `emotions` | The 8 selectable emotion icons |
| `advice_cards` | AI-generated (or human-reviewed) coping advice per emotion |
| `check_in_sessions` | One row per user emotion tap |
| `leads` | Email + payment status |
| `touchpoints` | Every meaningful interaction (capture, click, payment) |
| `audit_logs` | Every agent or system action |

## MVP Must-Haves (v1 checklist)
- [ ] Homepage renders emotion icon grid without login
- [ ] Tapping an emotion generates and stores a coping advice card
- [ ] Advice card displayed with clear, actionable copy
- [ ] Email capture gate before full advice is revealed
- [ ] Stripe Checkout live and able to accept a real payment
- [ ] Payment webhook updates lead to `paid` status
- [ ] Seed data makes the app demoable on first load

## Non-Goals (v1)
- Per-user login or personal history dashboard
- Mobile app or push notifications
- Multiple pricing tiers or coupon codes
- Mood trend charts or analytics
- Team / bulk licensing

## Success Criteria
A visitor lands on the homepage, taps **Stressed**, sees a spinner then a coping advice card, enters their email, clicks **Unlock Full Access**, completes Stripe Checkout with a real card, and lands on the confirmation page — all within 3 minutes. The lead row in the database shows `subscription_status = paid` and a `paid_at` timestamp.
