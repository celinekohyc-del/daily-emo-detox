# Agentic Layer — Daily Emo Detox

## Risk Classification
| Action | Risk | Trigger | Approval |
|---|---|---|---|
| Tag emotion tap + write touchpoint | Low | Every tap | Auto |
| Score lead urgency | Low | Lead created | Auto |
| Draft AI advice card | Low | Admin triggers | Auto-draft, held for review |
| Mark lead as paid | Medium | Stripe webhook | Auto (webhook signature verified) |
| Send welcome email to lead | Medium | payment_success | Auto after webhook confirmed |
| Approve AI advice card for display | Medium | Admin reviews draft | Admin click required |
| Create Stripe checkout session | High | User clicks Unlock | Initiated by user action; logged |
| Issue refund | Critical | — | Human only — via Stripe dashboard |
| Delete lead or advice card | Critical | — | Human only |

## Named Tools (v1)
- `create_touchpoint(lead_id, event_type, emotion_id)` — low risk, auto
- `create_stripe_session(lead_id, email)` — high risk, user-initiated, logged
- `mark_lead_paid(stripe_session_id)` — medium, webhook-triggered, signature-gated
- `draft_advice_card(emotion_id, prompt)` — low, admin-triggered, stored as unreviewed

## Audit Log Fields Written Per Action
`actor`, `action`, `target_table`, `target_id`, `payload` (sanitised), `risk_level`, `created_at`

## v1 vs Later
**v1:** only `create_touchpoint` and `create_stripe_session` and `mark_lead_paid` are live. 
**Later:** AI draft tool, email send tool, admin approval workflow UI.
