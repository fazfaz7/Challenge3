# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Lyngo / ItMeans** — an iOS vocabulary-builder app for language learners. Users capture words/phrases they encounter, add explanations later, and mark them as learned. Includes a home-screen widget.

## Build & Run

Open `Challenge3.xcodeproj` in Xcode and run on a simulator or device (iOS 17+). There are no build scripts or package managers — all dependencies are Apple frameworks.

To run a single Swift test: use Xcode's test navigator or `⌘U`. There are currently no automated tests in the project.

## Architecture

**SwiftUI + SwiftData** throughout. The app entry point (`Challenge3App.swift`) sets up a shared `modelContainer` for `LearnElement` and `Category`, and injects `LanguageStore.shared` as an environment object.

### Data models (`Model/LearnElement.swift`)
- `LearnElement` — a word or phrase. Key fields: `userEntry`, `explanation`, `isCompleted`, `language` (string like `"Italian 🇮🇹"`), `learnType` (`.newPhrase` / `.howToSay`), `category`.
- `Category` — emoji + name, used to group elements.
- `LanguageHelper` — static helpers to extract the flag emoji and localized name from a language string.

### Persistence split
- SwiftData `modelContainer` persists `LearnElement` and `Category`.
- `LanguageStore` (singleton `ObservableObject`) persists the user's list of active languages to `Documents/user_languages.json` independently of SwiftData.
- `@AppStorage` keys store lightweight state: `selectedLanguage`, `userName`, `hasSeenOnboarding`, and one-time migration flags.

### Item lifecycle
New items land in **To Review** (`isCompleted = false`). Opening an item shows `DetailView` where the user writes an explanation and taps "Mark complete" → `isCompleted = true` → item moves to **My Collection**.

### Three main tabs
| Tab | Root View | Purpose |
|-----|-----------|---------|
| To Review | `ContentView` | Pending items; add new words |
| My Collection | `CollectionView` → `CollectionDetailView` | Completed items, filterable by category |
| Settings | `SettingsView` | User profile; manage languages |

### Key view files
- `ContentView.swift` also contains `WordElementView`, `NewPhraseView`, `SectionSettingsView`, `AddLanguageView`, and `ProgressRing`.
- `DetailView.swift` also contains `TextToSpeechService`, `TextToSpeechViewModel`, and `AddLanguageView` (a duplicate — the canonical one is in `ContentView.swift`).
- The original `TextToSpeechService` and `TextToSpeechViewModel` in `Utilities/Speech/` are entirely commented out; the live implementations are inline in `DetailView.swift`.

### Widget (`Challenge3WidgetExtension/`)
`AppIntentConfiguration` widget using SwiftData. Displays a random **completed** word. Configurable by language and time range via `ConfigurationAppIntent`. Supports `.systemSmall` and `.systemMedium` families. Widget must share the same `modelContainer` as the main app.

### Onboarding
`hasSeenOnboarding` uses **inverted** logic: `true` = not yet seen (show onboarding), `false` = already completed. Triggered via `.fullScreenCover(isPresented: $hasSeenOnboarding)`.

### One-time data migrations
`ContentView.onAppear` runs guarded SwiftData migrations controlled by `@AppStorage` flags:
- `hasMigratedLanguages` — backfills `language` on old `LearnElement` rows that had `nil`.
- `hasPortugueseFlagMigrated` — renames `"Portuguese 🇵🇹"` → `"Portuguese 🇧🇷"` everywhere.

### Brand styling
Teal gradient used everywhere: `Color(red: 0.08, green: 0.72, blue: 0.65)` → `Color(red: 0.1, green: 0.7, blue: 0.8)`. All backgrounds use `.ultraThinMaterial` / `.thinMaterial`.

### Localization
App UI is localized into English, Spanish, and Italian (`AppLocale`). Language strings follow the pattern `"Italian 🇮🇹"` (name + flag emoji). Adding a new supported learning language requires updating the hardcoded `allLanguages` arrays in `OnboardingView.swift` and `DetailView.swift`, the `TextToSpeechService.speak` language-matching block, and any localization `.strings` files.
