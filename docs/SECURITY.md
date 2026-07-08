# Security — Daily Emo Detox

## Secret Handling
- `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `OPENAI_API_KEY` live in Vercel environment variables — never imported into any client component
- Supabase `service_role` key used only in server-side API routes (`/api/*`)
- Public Supabase anon key is safe for client use with RLS enforced

## Permission Model (v1 → lock-down)
- **v1:** permissive RLS policies — demo works without login
- **Lock-down sprint:** policies replaced with `auth.uid() = user_id`; paid status checked server-side against `leads` table using service role
- Stripe webhook verified with `stripe.webhooks.constructEvent` + `STRIPE_WEBHOOK_SECRET` before any DB write

## Approved Tools Rule
- Only named server-side functions touch the DB or external APIs
- No raw `eval`, `run_any`, or dynamic query construction
- Every meaningful write goes through a typed Supabase client call with explicit table + columns

## Audit Principle
- Every payment event, advice approval, and admin action writes an `audit_log` row
- Audit logs are append-only (no delete policy in production)
- If a task involves irreversible money movement or data deletion: stop, do not automate — route to a human
