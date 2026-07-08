# Security

## Secret Handling
- `OPENAI_API_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `SUPABASE_SERVICE_ROLE_KEY` — server-side env vars only. Never in `NEXT_PUBLIC_*`.
- Only `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` exposed to the client (safe by design).
- Stripe Checkout session created server-side via `/api/checkout`; client receives only the redirect URL.

## Permission Model (v1 → lock-down)
- v1: RLS policies are permissive for demo (open read + write).
- Lock-down sprint: every table gets `auth.uid() = user_id` for write; `paid` leads can read their own advice cards.
- `audit_logs` becomes admin-read-only.
- Stripe webhooks verified with `STRIPE_WEBHOOK_SECRET` before any DB write.

## Approved-Tools Rule
No agent or API route may call arbitrary external services. Only the named tools in AGENTIC_LAYER.md are permitted. New tools require an explicit addition to that list.

## Audit Principle
Every meaningful state change (advice generated, payment received, status updated) writes a row to `audit_logs` before the response is returned. No fire-and-forget mutations.

## Payments — Stop and Verify
Stripe integration touches real money. Before going live: verify webhook signature validation works with Stripe CLI, confirm idempotency key on checkout session creation, and test refund flow manually in Stripe dashboard. Do not shortcut this.
