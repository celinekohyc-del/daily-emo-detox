# Data Model — Daily Emo Detox

## `emotions`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable, for future owner-scoping |
| name | text | e.g. "Stressed" |
| icon_emoji | text | e.g. "😫" |
| color_hex | text | UI accent colour |
| display_order | integer | grid sort order |
| created_at | timestamptz | |

## `advice_cards`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| emotion_id | uuid FK → emotions | |
| headline | text | e.g. "Release the pressure valve" |
| body | text | **AI field** |
| body_source | text | "seed" / "openai-gpt4" |
| body_confidence | numeric | 0–1 |
| body_review_status | text | "unreviewed" / "approved" / "rejected" |
| breathing_exercise | text | |
| affirmation | text | |
| is_premium | boolean | gate flag |
| created_at | timestamptz | |

## `leads`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable; linked at auth lock-down |
| email | text | |
| name | text | optional |
| source_emotion_id | uuid FK → emotions | which emotion triggered capture |
| stripe_session_id | text | |
| stripe_customer_id | text | |
| paid_at | timestamptz | null = free |
| plan | text | "free" / "paid" |
| created_at | timestamptz | |

## `touchpoints`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| lead_id | uuid FK → leads | nullable before email capture |
| event_type | text | "emotion_tap" / "advice_view" / "lead_captured" / "checkout_started" / "payment_success" |
| emotion_id | uuid FK → emotions | |
| advice_card_id | uuid FK → advice_cards | nullable |
| metadata | jsonb | any extra context |
| created_at | timestamptz | |

## `audit_logs`
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| actor | text | "system" / "admin" / user id |
| action | text | e.g. "stripe_webhook_received" |
| target_table | text | |
| target_id | uuid | |
| payload | jsonb | |
| risk_level | text | "low" / "medium" / "high" / "critical" |
| created_at | timestamptz | |

## RLS (v1 — demo-first)
All tables: permissive read + write for anonymous visitors. Replaced with owner-scoped policies in the Lock-Down sprint.
