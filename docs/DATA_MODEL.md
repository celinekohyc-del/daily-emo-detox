# Data Model — Daily Emo Detox

## emotions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| label | text | e.g. "Stressed" |
| icon_emoji | text | e.g. "😤" |
| category | text | e.g. "work", "home", "social" |
| sort_order | int | display order |
| created_at | timestamptz | |

## advice
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| emotion_id | uuid → emotions | |
| body | text | the calming advice text |
| tier | text | 'free' or 'paid' |
| ai_body | text | AI-generated alternative |
| ai_body_source | text | model + prompt version |
| ai_body_confidence | numeric | 0–1 |
| ai_body_review_status | text | default 'unreviewed' |
| user_id | uuid nullable | owner scope (post lock-down) |
| created_at | timestamptz | |

## sessions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | null for anonymous |
| emotion_id | uuid → emotions | |
| advice_id | uuid → advice | |
| fingerprint | text | browser fingerprint for anon rate-limit |
| created_at | timestamptz | |

## leads
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| email | text | |
| source | text | e.g. 'paywall_modal' |
| created_at | timestamptz | |

## subscriptions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| stripe_customer_id | text | |
| stripe_subscription_id | text | |
| status | text | 'active','canceled','past_due' |
| plan | text | 'monthly','lifetime' |
| created_at | timestamptz | |

## RLS
All tables: RLS enabled. v1 permissive policies (select + all using true). Lock-down sprint replaces with `auth.uid() = user_id`.