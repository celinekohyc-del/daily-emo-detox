# Agentic Layer — Daily Emo Detox

## Risk Levels & Actions

### Low — Auto (no approval)
- Tag new advice row with emotion category
- Score advice confidence and set review_status
- Summarize weekly emotion usage for admin view

### Medium — Light Approval
- Draft follow-up email to unconverted lead (builder reviews before send)
- Flag advice row as 'needs_review' and surface in admin queue

### High — Approval Required
- Send marketing email to lead list
- Upgrade or downgrade a subscription plan

### Critical — Human Only
- Issue refund via Stripe
- Delete user data / GDPR erasure
- Modify Stripe webhook config

## Named Tools (approved list)
- `generate_advice(emotion_id)` — calls OpenAI, stores result with source/confidence
- `flag_advice(advice_id, reason)` — sets review_status
- `create_checkout_session(email, plan)` — Stripe Checkout via Edge Function
- `update_subscription(stripe_event)` — webhook handler only
- `log_action(table, row_id, action, actor)` — writes to audit_logs

## Audit Log Fields
`id, created_at, actor_id, actor_type (user/system/webhook), table_name, row_id, action, payload_json`

## v1 vs Later
**v1:** generate_advice + create_checkout_session + update_subscription + log_action 
**Later:** auto-email drip, usage trend summaries, churn-risk alerts
