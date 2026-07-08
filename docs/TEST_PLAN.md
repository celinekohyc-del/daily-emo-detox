# Test Plan — Daily Emo Detox

## v1 Success Scenario (Manual)
1. Open `/` in incognito — emotion grid renders (8 icons visible)
2. Tap **Stressed** — advice card appears with headline, body, breathing exercise, affirmation
3. Check Supabase `touchpoints` — one row with `event_type = 'emotion_tap'`
4. Tap **Anxious** — email capture modal appears
5. Submit `test@example.com` — modal closes, advice card shown (partial access)
6. Check `leads` table — one row, `source_emotion_id` matches Anxious, `paid_at` null
7. Click **Unlock Full Access** — redirected to Stripe Checkout
8. Enter card `4242 4242 4242 4242`, any future date, any CVC — complete payment
9. Redirected to `/success` — confirmation message shown
10. Check `leads` table — `paid_at` is set, `plan = 'paid'`
11. Check `audit_logs` — row with `action = 'payment_success'`
12. Return to `/` — tap any emotion — no modal appears, full card shown immediately

## Empty States
- Delete all emotion rows → homepage shows "No emotions found. Check back soon."
- Submit email capture with blank email → inline error "Please enter a valid email"
- Stripe webhook with wrong signature → 400 returned, no DB write, audit_log records failure attempt

## Error States
- Supabase offline → advice card shows "Unable to load advice right now. Please try again."
- Stripe session creation fails → user sees "Checkout unavailable — please try again or contact support."
- Duplicate email submit → no duplicate `leads` row created; user sees success (idempotent)

## Permission Check (Sprint 4)
- Log in as User A → tap emotions → log out → log in as User B → verify User B's `touchpoints` query returns 0 rows from User A
- Unauthenticated request to `leads` table via Supabase client → returns empty result (RLS blocks)

## Never Mark Done Until
- Every button click persists a real row (verified in Supabase table viewer)
- Stripe test payment confirmed in Stripe dashboard + `leads.paid_at` set
- No `.env` values logged or exposed in browser network tab
