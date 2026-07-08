# Agentic Layer

## Risk Levels & Actions

### Low — auto-execute, log only
- `generate_advice_card` — call OpenAI, store result, serve to user
- `tag_emotion_session` — write check_in_session row
- `score_advice_confidence` — attach confidence to advice_card row

### Medium — light approval (admin confirms before run)
- `update_advice_review_status` — approve or reject a flagged advice card
- `create_touchpoint_event` — log a lead interaction

### High — always requires approval before execution
- `send_email_to_lead` — any outbound email (drip, confirmation)
- `create_stripe_checkout` — initiates a charge flow (server-side only, never from client)

### Critical — human-only, no agent execution
- `refund_payment` — Stripe refund, must be done by builder in Stripe dashboard
- `delete_lead` — permanent removal, requires explicit human action
- `export_all_leads` — bulk PII export

## Named Tools (approved list)
| Tool | Risk | v1? |
|---|---|---|
| `openai_chat_completion` | low | yes |
| `supabase_insert` | low | yes |
| `stripe_create_checkout_session` | high | yes |
| `stripe_webhook_verify` | low | yes |
| `send_transactional_email` | high | later |

## Audit Log Fields
Every agent action writes: `action`, `entity_type`, `entity_id`, `risk_level`, `metadata` (full payload), `created_at`, `user_id` (null if anonymous).

## Approval Flow
Draft → stored in `audit_logs` with status `pending` → admin confirms → action executes → status updated to `completed`.
