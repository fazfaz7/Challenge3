# ItMeans — Product Roadmap & Improvement Suggestions

*Generated: June 2026*

---

## Core Positioning

ItMeans owns the **"real life capture"** niche in language learning. Not a course app, not a flashcard app — a frictionless field notebook for intermediate/advanced learners who are already immersed. This is underserved and worth doubling down on.

**The one thing:** *you heard a word, you saved it, you learned it later.*

---

## Priority Features

### 1. Shareable Word Cards ⭐ Highest Impact
Generate a beautiful image card for each word, shareable to Instagram Stories, TikTok, WhatsApp.

```
┌─────────────────────┐
│  🇮🇹                 │
│                     │
│   affascinante      │
│   ───────────       │
│   fascinating       │
│                     │
│              ItMeans│
└─────────────────────┘
```

- Add a share button on `CollectionDetailView`
- Use SwiftUI's `ImageRenderer` to export the card as an image
- Include the word, explanation, flag, and ItMeans branding
- **Why it matters:** every share is a free ad. This is the viral loop. Directly powers the Instagram/TikTok strategy.

---

### 2. iCloud Sync ⭐ Trust & Retention
Users who lose their phone lose their entire word collection. That kills reviews.

- SwiftData has built-in CloudKit support — medium difficulty
- Existing users: CloudKit auto-uploads local data on first launch
- **Watch out for:** CloudKit has stricter schema requirements (optional fields, relationships). Audit `LearnElement` before enabling.
- Test thoroughly on a device that already has data before releasing
- **Why it matters:** vocabulary collections are built over months. Losing them = 1-star review.

---

### 3. Context / Where Field
Add a field to each word: *where did you hear it?*

Examples: "At a restaurant in Rome", "Watching Netflix", "My Italian girlfriend said it"

- Add an optional `context: String?` field to `LearnElement`
- Show it in `DetailView` and `CollectionDetailView`
- **Why it matters:** memory is tied to context. Also incredible content — "47 words I learned in Sicily 🇮🇹"

---

### 4. Share Extension — Capture From Anywhere
Right now users must open the app to save a word. They encounter words in Safari, Instagram, WhatsApp, Netflix.

- Build an iOS Share Extension (separate target in Xcode)
- Select any text in any app → tap Share → ItMeans → mini capture sheet appears
- **Why it matters:** removes the biggest friction point in the whole product loop

---

### 5. Better Quiz / Spaced Repetition
Currently: 5 multiple choice questions per day, random words. Too light.

Improvements:
- **More question types:** fill in the blank, type the answer, audio-only recognition
- **Smarter word selection:** surface words you haven't seen in a while (basic SRS)
- **Quiz streaks and milestones:** "10 days in a row" rewards
- **Why it matters:** daily engagement and retention

---

### 6. Streak Prominence
You have a streak counter but it's buried in Settings. Duolingo's retention is largely streak psychology.

- Move streak to the home screen header, next to the language
- Add a "streak at risk" notification if the user hasn't opened the app by evening
- Celebrate milestones (7 days, 30 days, 100 days)
- **Why it matters:** the single biggest driver of daily retention in habit apps

---

## Smaller UX Improvements

| Item | Where | Notes |
|---|---|---|
| "New Expression" badge hardcoded | `CollectionDetailView` line ~32 | Doesn't check `learnType`, so "How to Say" words also say "New Expression" |
| Onboarding captures first word live | `OnboardingView` | Instead of explaining the app, have users actually save one word during onboarding — immediate value |
| Haptic feedback on mark complete | `DetailView` | Small but satisfying. Use `UIImpactFeedbackGenerator` |
| "Learned X words this week" notification | New | Positive reinforcement push notification, drives re-engagement |
| Export collection as PDF/CSV | `CollectionView` | Power users want this. Good for App Store reviews |

---

## Social Media Strategy (Instagram + TikTok)

### Content Pillars That Will Work

1. **"Word of the day"** — one word, the flag, the story of where you heard it. Simple, repeatable, algorithm-friendly. Use the shareable cards feature.

2. **Trip content** — "I captured X words during my trip to [country]." Travel + language learning is a huge overlap audience. Show the calendar view and word list.

3. **"5 words [language] natives use that you won't learn in school"** — this format consistently goes viral. Easy to batch-produce.

4. **Transformation content** — "My ItMeans collection after 6 months of learning Italian." Show the stats, the calendar heatmap, the categories.

5. **"Capture in the moment" POV** — short video: you're at a restaurant, you hear a word, you open ItMeans and save it. 15 seconds. Authentic and directly shows the product value.

### Key Insight
The shareable word cards (Priority #1) are **essential** for the social strategy. Without them, your content is disconnected from the product. With them, your users become your creators.

---

## What Would Actually Worry Me

1. **No iCloud sync at scale** — fine now with few users. Dangerous when you have thousands.
2. **Discoverability** — the App Store is brutal without marketing. The social strategy solves this, but only if the shareable cards feature exists to close the loop.
3. **Monetization** — not defined yet. Consider: free for 1 language, premium for unlimited languages + iCloud sync + advanced quiz. Or a one-time purchase. Decide before you scale.

---

## Monetization Ideas

| Model | Pros | Cons |
|---|---|---|
| Free + one-time purchase ("Pro") | Simple, no subscription fatigue | Lower LTV |
| Freemium (1 language free, more = paid) | Natural upsell as users grow | Could frustrate existing users |
| Subscription | Higher LTV | Hard to justify for a simple app |
| **Recommendation** | One-time "ItMeans Pro" purchase (~$2.99–4.99) unlocking iCloud sync, unlimited languages, advanced quiz | Matches the app's simplicity |

---

## Build Order Recommendation

1. Fix `CollectionDetailView` "New Expression" hardcode bug — 10 mins
2. Shareable word cards — 1-2 days
3. Context/where field — half a day
4. iCloud sync — 1 weekend (audit schema first)
5. Share extension — 2-3 days
6. Streak on home screen — a few hours
7. Better quiz — 2-3 days

---

*Total estimated effort to a "top app" version: ~2-3 focused weeks of development*
