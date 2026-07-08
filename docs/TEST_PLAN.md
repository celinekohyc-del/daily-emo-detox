# Test Plan — Daily Emo Detox

## Core Success Scenario (manual)
1. Open app in incognito — emotion grid renders without login.
2. Tap "Stressed" → advice card appears → `sessions` row exists in Supabase.
3. Tap 3 more emotions → on 4th tap, paywall modal appears.
4. Enter email in modal → `leads` row inserted.
5. Click "Unlock Full Access" → redirected to Stripe Checkout (test mode).
6. Complete payment with card `4242 4242 4242 4242` → redirect to app.
7. Tap any emotion → advice shows with no paywall → `subscriptions` row status = 'active'.

## Empty / Error Cases
| Scenario | Expected |
|---|---|
| No emotions seeded | Grid shows "No emotions available" message, not a blank page |
| Advice fetch times out | Card shows "Couldn't load advice — tap to retry" |
| Stripe Checkout API error | Modal shows "Payment unavailable — try again" with support link |
| Webhook signature invalid | 400 returned, nothing written to DB, error logged |
| Email field blank on paywall | Inline validation, form does not submit |
| User revisits after payment (no login) | Fingerprint checked → paywall skipped for rest of session |

## Regression Checks (each sprint)
- [ ] Session row written on every tap
- [ ] Daily tap count resets at midnight UTC
- [ ] Stripe secret never appears in browser network tab
- [ ] Admin page not reachable without correct credential
- [ ] Audit log gains a row for every subscription change