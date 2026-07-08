# Intelligence Layer — Daily Emo Detox

## Messy Input
User taps an emotion icon — no free text, no context. The structured signal is: `emotion_id + timestamp + fingerprint`.

## Auto-Structure Schema (per session event)
```json
{
  "emotion_id": "uuid",
  "label": "Overwhelmed",
  "hour_of_day": 14,
  "day_of_week": "Tuesday",
  "tap_index_today": 2,
  "paid_user": false
}
```

## Events to Track
- `emotion_tapped` — every tap
- `paywall_shown` — tap limit hit
- `lead_captured` — email entered
- `checkout_started` — Stripe redirect
- `subscription_activated` — webhook confirmed

## Scoring Rules (rule-based v1)
- **Hot emotion:** emotion tapped >3× in one day → flag as recurring
- **Conversion lead score:** lead_captured + checkout_started within 10 min = high-intent
- **Churn risk:** active subscriber with 0 sessions in 7 days = at-risk

## What Gets Ranked
- Advice cards: most-tapped emotions surface first in the grid (sort by session count)

## v1 vs Later
| Feature | v1 | Later |
|---|---|---|
| Advice text | Static seed | OpenAI-generated, stored with confidence score |
| Emotion ranking | Session count | ML-weighted by time-of-day & user history |
| Personalisation | None | Per-user emotion pattern summary |
| Mood trend | None | Weekly chart from sessions |