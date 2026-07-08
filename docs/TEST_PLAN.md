# Test Plan

## Core Success Scenario (manual)
1. Open `/` in an incognito browser window.
2. **Verify:** 8 emotion icon cards are visible. No login prompt.
3. Click **Stressed**.
4. **Verify:** Loading spinner appears immediately.
5. **Verify:** Within 5 seconds an advice card appears with non-empty text.
6. **Verify:** `advice_cards` table has a new row; `advice_confidence` is populated.
7. **Verify:** Email capture modal appears.
8. Enter `test@example.com` and submit.
9. **Verify:** `leads` row inserted with `subscription_status = free`; touchpoint `email_captured` logged.
10. Click **Unlock Full Access**.
11. **Verify:** Redirected to Stripe Checkout (test mode).
12. Enter Stripe test card `4242 4242 4242 4242`, any future date, any CVC.
13. Complete payment.
14. **Verify:** Redirected to `/success` with confirmation copy.
15. **Verify:** `leads` row now shows `subscription_status = paid` and `paid_at` is not null.
16. **Verify:** `touchpoints` has `payment_completed` event.
17. **Verify:** `audit_logs` has `payment_webhook_received` entry.

## Empty State
- Delete all rows from `emotions` (dev only). Visit `/`. **Expect:** empty-state message "No emotions loaded yet" — no crash.

## Error States
- Set `OPENAI_API_KEY` to an invalid value. Tap an emotion. **Expect:** fallback seeded advice card is served; error toast "Advice loaded from cache"; no 500 shown to user.
- Submit email capture form with an invalid email. **Expect:** inline validation error; no DB insert.
- Cancel Stripe Checkout mid-flow. **Expect:** user returned to advice card page; `leads` row remains `free`; no duplicate rows.

## Stripe Webhook
- Replay a `checkout.session.completed` event via Stripe CLI. **Expect:** `leads` updated to `paid` exactly once (idempotent — replaying does not create duplicate rows).

## Security Checks
- Inspect browser network tab: confirm `STRIPE_SECRET_KEY` and `OPENAI_API_KEY` are never present in any response or JS bundle.
- Confirm Stripe webhook returns 400 if signature header is missing or tampered.
