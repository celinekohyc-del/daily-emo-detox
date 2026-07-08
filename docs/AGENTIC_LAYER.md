# Agentic Layer — Daily Emo Detox

## Risk Tiers

### Low — Auto (no approval needed)
- Tag a session with recurring-emotion flag
- Score a lead as high-intent or cold
- Select the best-matching advice row for an emotion tap

### Medium — Light Approval
- Draft a follow-up email to a cold lead (builder reviews before send)
- Suggest a new advice row based on low-rated sessions

### High — Always Approval
- Send email to a lead or subscriber
- Apply a discount coupon via Stripe API

### Critical — Human Only
- Issue a refund via Stripe
- Delete a user account or any subscription record
- Export PII data

## Named Tools (v1)
- `select_advice(emotion_id)` — query advice table, return best match
- `write_session(emotion_id, advice_id, fingerprint)` — insert session row
- `capture_lead(email, source)` — insert lead row
- `create_stripe_checkout(plan)` — server-side Stripe API call
- `upsert_subscription(stripe_payload)` — webhook handler

## Audit Log Fields
`id, actor_type (user|system), actor_id, action, target_table, target_id, payload_snapshot, risk_level, created_at`

## v1 vs Later
- v1: tools 1–5 only, all invoked by user action
- Later: scheduled agent checks churn risk daily, drafts win-back email for approval