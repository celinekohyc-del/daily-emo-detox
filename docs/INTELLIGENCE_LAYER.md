# Intelligence Layer — Daily Emo Detox

## v1: Rule-Based (No AI Required)
- Advice card is selected by `emotion_id` — deterministic lookup
- Gate logic: tap count ≥ 2 → show email modal (stored in session, not DB)
- Paid status: `leads.paid_at IS NOT NULL` → full access

## Messy Input → Structured Data
User taps an emoji → system resolves to:
```json
{
  "emotion_id": "a100...",
  "emotion_name": "Stressed",
  "advice_card_id": "b100...",
  "event_type": "emotion_tap",
  "session_tap_count": 2
}
```
This is written as a `touchpoint` row immediately.

## Events Tracked
| Event | Trigger |
|---|---|
| `emotion_tap` | Any emotion icon click |
| `advice_view` | Advice card fully rendered |
| `lead_captured` | Email form submitted |
| `checkout_started` | Stripe session created |
| `payment_success` | Webhook confirmed |

## Scoring (v1 rule-based)
- Lead score = sum of touchpoints × emotion urgency weight (Hopeless=10, Stressed=8, Anxious=7 … )
- High-score leads surfaced first in future admin view

## Later (AI on top)
- GPT-4 generates personalised advice variation per emotion + user history
- `body_source = 'openai-gpt4'`, `body_confidence` from logprob, `body_review_status = 'unreviewed'`
- Admin approves before card goes live
- Model learns which cards correlate with repeat visits (engagement signal)
