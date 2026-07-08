# Intelligence Layer

## Messy Input
User taps an emotion icon (no free text in v1). Emotion name is the only signal.

## Auto-Structure Schema (what the AI route produces)
```json
{
  "emotion_id": "uuid",
  "advice_text": "Take 5 slow breaths...",
  "advice_source": "openai-gpt-4o",
  "advice_confidence": 0.91,
  "advice_review_status": "unreviewed"
}
```

## Events to Track
- `emotion_tapped` — which emotion, timestamp, session token
- `advice_generated` — emotion, model, confidence score
- `advice_fallback_used` — AI failed, seeded card served
- `advice_thumbs_up/down` — (later) user feedback

## Scoring Rules (rule-based v1)
- Confidence ≥ 0.85 → auto-display, status = `unreviewed`
- Confidence < 0.85 → display with flag, status = `unreviewed`, queued for admin review
- Human-seeded cards → confidence = 1.0, status = `approved`
- Rejected cards → never served to users

## What Gets Ranked
- v1: single advice card per emotion (highest-confidence approved card as fallback)
- Later: rank multiple cards per emotion by thumbs-up rate + recency

## v1 vs Later
| | v1 | Later |
|---|---|---|
| Input | emotion tap only | emotion + optional free-text journal |
| Model | GPT-4o, one call | Fine-tuned on feedback data |
| Confidence | returned by prompt | calibrated against thumbs signal |
| Review | admin queue | auto-approve if thumbs > 90% |
