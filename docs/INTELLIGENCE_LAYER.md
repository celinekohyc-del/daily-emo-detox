# Intelligence Layer — Daily Emo Detox

## Messy Input
User taps an emotion icon — no free text, highly structured by design.

## Auto-Structure (advice generation)
```json
{
  "emotion": "Stressed",
  "category": "stress",
  "advice_body": "Take 4 slow breaths…",
  "source": "openai-gpt4",
  "confidence": 0.87,
  "review_status": "unreviewed"
}
```

## Events to Track
- Emotion tapped (emotion_id, timestamp, visitor_token)
- Advice displayed (advice_id, session_id)
- Paywall hit (session count, touchpoint)
- Email captured
- Checkout started / completed

## Scoring Rules (rule-based first)
- **Usage score:** sessions this week (low <3, medium 3–7, high 7+)
- **Conversion score:** lead captured + paywall shown → flag for follow-up email
- **Advice quality:** confidence < 0.7 → auto-flag review_status = 'needs_review'

## What Gets Ranked
- Advice rows sorted by confidence DESC per emotion
- Top-ranked unreviewed advice surfaced first in admin queue

## v1 vs Later
**v1:** Seeded advice; OpenAI fallback on cache miss; rule-based flagging 
**Later:** Personalized advice based on repeat emotions; sentiment trend over time; A/B advice variants
