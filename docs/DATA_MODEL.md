# Data Model — Daily Emo Detox

## emotions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | owner scope (lock-down sprint) |
| created_at | timestamptz | |
| label | text | e.g. "Stressed" |
| icon_url | text | emoji or image path |
| category | text | stress/anger/sadness/anxiety/overwhelm |
| sort_order | int | display order |

## advice
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| created_at | timestamptz | |
| emotion_id | uuid → emotions | |
| body | text | coping advice copy |
| body_source | text | "openai-gpt4" / "human" |
| body_confidence | numeric | 0–1 |
| body_review_status | text | default 'unreviewed' |

## sessions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| created_at | timestamptz | |
| emotion_id | uuid → emotions | |
| advice_id | uuid → advice | |
| visitor_token | text | anon browser fingerprint |

## leads
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| created_at | timestamptz | |
| email | text unique | |
| touchpoint | text | e.g. "paywall-modal" |
| converted | boolean default false | |

## subscriptions
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| created_at | timestamptz | |
| email | text | |
| plan | text | 'free' / 'pro' |
| stripe_customer_id | text | |
| stripe_subscription_id | text | |
| status | text | 'active' / 'canceled' / 'trialing' |

## RLS
All tables: RLS enabled. v1 permissive policies (select/all = true). Lock-down sprint replaces with `auth.uid() = user_id`.
