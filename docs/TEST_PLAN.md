# Test Plan — Daily Emo Detox

## Core Success Scenario (manual)
1. Open app URL — emotion grid renders with 8+ icons (**ready state**)
2. Tap "Stressed" — advice card appears within 2 s; confirm session row in Supabase `sessions`
3. Tap two more emotions — third tap triggers paywall modal
4. Enter test email in capture form — confirm `leads` row inserted, touchpoint = 'paywall-modal'
5. Click "Go Pro" — redirected to Stripe Checkout (test mode)
6. Complete payment with Stripe test card `4242 4242 4242 4242`
7. Land on `/success` — see "You're Pro" message
8. Confirm `subscriptions` row: plan='pro', status='active'
9. Confirm `audit_logs` row: action='subscription_activated'
10. Tap emotion again — no paywall; session saved

## Empty States
- Emotion with no seeded advice → fallback copy renders, no blank card
- `advice` table empty for emotion → AI fallback fires (Sprint 3)
- Stripe webhook delayed → subscription stays 'free'; user sees "payment pending" message

## Error States
- Network offline during emotion tap → error toast; no broken UI
- Invalid Stripe webhook signature → 400 returned; no DB update
- OpenAI timeout → cached seeded advice served; no crash

## Loading States
- Advice card shows skeleton while fetching
- Checkout button shows spinner on click; disabled to prevent double-submit

## Permission Check (Sprint 4)
- Log in as User A; confirm cannot fetch User B's sessions via direct Supabase query
- Confirm `/admin/advice` returns 403 for non-admin users
