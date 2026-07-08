# Security — Daily Emo Detox

## Secret Handling
- `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `SUPABASE_SERVICE_ROLE_KEY` live in Vercel environment variables only — never in client bundles or committed to git.
- All Stripe calls happen in `/api/*` server routes; the client only receives a Checkout URL.
- Supabase anon key is safe to expose; service-role key is server-only.

## Permission Model
- v1: permissive RLS (read/write open for demo). No sensitive PII at risk until lock-down sprint.
- Lock-down sprint: replace all v1 policies with `auth.uid() = user_id`. Subscription status read server-side only.
- Anonymous sessions identified by browser fingerprint — no personal data stored until email captured.

## Approved-Tools Rule
- Agents and server routes call only the named tools in `AGENTIC_LAYER.md`.
- No `eval`, no raw SQL from user input, no dynamic `fetch` to arbitrary URLs.
- Stripe webhook endpoint validates signature before processing any payload.

## Audit Principle
- Every meaningful write (session, lead, subscription change) appends a row to `audit_logs`.
- Audit rows are insert-only — no update or delete policy on that table, ever.
- High/critical actions require a second human confirmation step before execution.