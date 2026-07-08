# Data Model

## `emotions`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | gen_random_uuid() |
| user_id | uuid | nullable, future owner-scoping |
| name | text | e.g. "Stressed" |
| icon | text | emoji |
| color | text | hex |
| created_at | timestamptz | default now() |

## `advice_cards`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| emotion_id | uuid FK → emotions | |
| advice_text | text | **AI field — value** |
| advice_source | text | **AI field — source** (e.g. `openai-gpt-4o`) |
| advice_confidence | numeric | **AI field — confidence** 0–1 |
| advice_review_status | text | **AI field — review_status** (`unreviewed` / `approved` / `rejected`) |
| created_at | timestamptz | |

## `check_in_sessions`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| emotion_id | uuid FK → emotions | |
| advice_card_id | uuid FK → advice_cards | |
| session_token | text | anonymous browser token |
| created_at | timestamptz | |

## `leads`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| email | text | captured before payment |
| subscription_status | text | `free` / `paid` |
| stripe_customer_id | text | nullable |
| stripe_session_id | text | nullable |
| paid_at | timestamptz | nullable |
| created_at | timestamptz | |

## `touchpoints`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| lead_id | uuid FK → leads | |
| event_type | text | `email_captured`, `checkout_started`, `payment_completed` |
| metadata | jsonb | page, amount, etc. |
| created_at | timestamptz | |

## `audit_logs`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| action | text | e.g. `advice_generated`, `payment_webhook_received` |
| entity_type | text | table name |
| entity_id | uuid | row acted on |
| risk_level | text | `low` / `medium` / `high` / `critical` |
| metadata | jsonb | full payload snapshot |
| created_at | timestamptz | |

## RLS Notes
- All tables: v1 permissive (read + write open for demo).
- Lock-down sprint replaces with `auth.uid() = user_id` owner policies.
- `audit_logs` will become admin-only read in lock-down sprint.
