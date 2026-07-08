# Security — Daily Emo Detox

## Secret Handling
- `OPENAI_API_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` stored in Vercel + Supabase env vars only
- Never referenced in client-side code or exposed via API response
- Stripe public key (`NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`) is the only key allowed in the browser

## Permission Model
- v1: permissive RLS (demo-safe, no user data yet)
- Lock-down sprint: every table policy updated to `auth.uid() = user_id`
- Stripe webhooks verified with `stripe.webhooks.constructEvent()` — reject unsigned payloads
- Edge Functions run with service-role key server-side; client never receives service-role key

## Approved Tools Rule
- Agents may only call named tools in `AGENTIC_LAYER.md`
- No raw SQL execution by AI; no `eval`; no dynamic function dispatch
- Every agent action writes to `audit_logs` before returning

## Audit Principle
- Every meaningful state change (advice generated, subscription updated, lead captured) logs actor, action, timestamp, and affected row ID
- Audit logs are append-only; no delete policy on that table

## Honest Stops
- Refunds and GDPR deletions: **do not automate** — handle manually via Stripe dashboard and Supabase Studio until volume justifies a reviewed workflow
