# Newsly - Flutter News App

Newsly is a cross-platform Flutter application that fetches content from a remote REST API and displays it through a clean and responsive user interface.

The project demonstrates API integration, asynchronous data handling, Cubit state management, local caching, offline support, search, category filtering, and news details.

## Features

* Fetch news from a remote REST API (DummyJSON)
* JSON data parsing with `NewsModel` + category inference
* Dio HTTP client with timeout + SharedPreferences cache fallback
* BLoC/Cubit state management (`NewsCubit`, `AccountCubit`)
* Loading, empty and error states with retry
* Search news by title, content, or tags
* Personalized feeds — **For You** (matched to interests) + **Top Stories** (all)
* Category filtering with 14 interests + expandable catalog
* Pull-to-refresh and offline banner
* News details screen with stats
* **User accounts & personalization** — Firebase Auth (email/password), Firestore profile + interactions (like / dislike / save)
* **Onboarding** — category picker on first sign-up (with Skip), editable later from Profile
* **Saved** articles (denormalized Firestore snapshot, offline-ready)
* **Profile** — avatar, saved/liked/disliked counters, interests, dark-mode toggle, language switcher, sign out
* **Localization** — English + Arabic (RTL) via `flutter_localizations` + `AppLocalizations`
* **Theming** — design-system tokens (`AppPalette`, `AppTypography`, `AppSpacing`, `AppRadius`), light default (splash forced light), dark mode toggle in Profile
* Brand splash (`BrandMark`) — always light, native Android splash forced white
* Local caching using SharedPreferences + Firestore offline persistence
* Responsive Flutter UI across phone sizes

## Technologies

* Flutter / Dart
* Dio, `cached_network_image`, `connectivity_plus`
* BLoC / Cubit (`flutter_bloc`)
* SharedPreferences (feed cache)
* Firebase — `firebase_core`, `firebase_auth`, `cloud_firestore` (accounts, profile, interactions)
* Localization — `flutter_localizations`, `intl` (EN/AR, RTL)
* DummyJSON REST API (`https://dummyjson.com/posts`)

## Architecture

Layered, feature-oriented:

```text
Presentation (screens + core/widgets)
    ↓
Cubits (NewsCubit, AccountCubit)
    ↓
Repositories (NewsRepository, SessionRepository → FirebaseSessionRepository)
    ↓
Services (ApiService / Firebase Auth + Firestore)
    ↓
REST API / Firestore
```

State routing: `AuthGate` → `AccountState` decides `AuthScreen` / `OnboardingScreen` / `MainShell` (Home / Saved / Profile). `visibleNews()` (`core/feed_filter.dart`) applies dislike filtering, For You vs Top Stories, and search.

For offline support:

```text
REST API
    ↓
JSON Response
    ↓
Local Cache (SharedPreferences: cached_news)
    ↓
Cached Content (+ Firestore denormalized article snapshots for Saved)
```

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
│
├── core/
│   ├── feed_filter.dart
│   ├── network/
│   │   └── api_service.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radius.dart
│   │   ├── app_theme.dart
│   │   ├── theme_controller.dart
│   │   └── locale_controller.dart
│   └── widgets/
│       ├── app_header.dart
│       ├── app_card.dart
│       ├── app_tag.dart
│       ├── app_loading.dart
│       ├── app_error_state.dart
│       ├── app_empty_state.dart
│       ├── app_spacing_box.dart
│       ├── app_section_header.dart
│       └── brand_mark.dart
│
├── cubit/
│   ├── account_cubit.dart
│   ├── account_state.dart
│   ├── news_cubit.dart
│   └── news_state.dart
│
├── data/
│   ├── models/
│   │   ├── news_model.dart
│   │   ├── news_catalog.dart
│   │   ├── user_profile.dart
│   │   └── saved_article.dart
│   └── repositories/
│       ├── news_repository.dart
│       ├── session_repository.dart
│       └── firebase_session_repository.dart
│
├── l10n/
│   ├── app_en.arb
│   ├── app_ar.arb
│   ├── text.dart
│   └── app_localizations*.dart
│
└── screens/
    ├── auth_gate.dart
    ├── auth_screen.dart
    ├── onboarding_screen.dart
    ├── main_shell.dart
    ├── home_screen.dart
    ├── saved_screen.dart
    ├── profile_screen.dart
    ├── news_details_screen.dart
    └── widgets/
        ├── news_feed.dart
        ├── news_card.dart
        ├── news_search_field.dart
        ├── offline_banner.dart
        ├── stat_card.dart
        ├── profile_avatar.dart
        └── profile_stats.dart
```

## API

The application uses the DummyJSON REST API to retrieve news-style content.

Endpoint:

```text
https://dummyjson.com/posts
```

The application processes the returned JSON and converts it into Dart models before displaying the data.

## Interests & Categories

Onboarding and the **For You** feed use `kNewsCategories` (`lib/data/models/news_catalog.dart`). 14 categories are available — Technology, Sports, Business, Politics, Health, Entertainment, Science, World, Automotive, Travel, Food, Education, Fashion, Lifestyle — each with an icon and keyword map for local `inferCategory()` (used until the API provides `category` directly). Labels are localized via `lib/l10n/text.dart` (`categoryLabel()`).

## Localization

`l10n.yaml` (`arb-dir: lib/l10n`, `generate: true`) + `flutter_localizations`/`intl`. `LocaleController` drives `MaterialApp.locale`; Profile offers an EN / عربي `SegmentedButton`. ARB keys cover all screens; generated `app_localizations*.dart` is committed and rebuilt with `flutter gen-l10n`.

## Theming

Design tokens: `AppPalette` (light/dark), `AppTypography` (Inter), `AppSpacing`, `AppRadius`. `AppTheme.light()/dark()` builds `ThemeData`. The app starts light (`ThemeController` defaults to `ThemeMode.light`); Profile toggles dark via a `Switch`. Both brand loading screens (`AuthGate` + `Home`) are forced light (`Theme(AppTheme.light())` + `AppPalette.light.canvas`) and the native Android splash is forced white (`values-night/styles.xml` `LaunchTheme` → `Theme.Light.NoTitleBar`, `drawable-v21/launch_background` → `@android:color/white`) so no black flash appears.

## Accounts & Saved

`SessionRepository` (abstract) → `FirebaseSessionRepository`:
- `users/{uid}` — profile `{name,email,preferredCategories}`
- `users/{uid}/interactions/{articleId}` — `{article,savedAt,isLiked,isDisliked,isSaved}`
Likes/dislikes are optimistic with rollback; `loadInteractions()` queries `where(...==true)` for the three interaction types. Firestore rules (`firestore.rules`, wired in `firebase.json`) scope reads/writes to `request.auth.uid == uid`.

## Offline Support

The latest successfully retrieved feed is cached locally using SharedPreferences (`cached_news`). If the device loses internet connectivity, the app shows the cached content with an offline indicator (`OfflineBanner`) and `NewsCubit.isOffline`. Saved articles carry a denormalized snapshot, so Saved works offline.

## Getting Started

### Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android emulator or physical device

### Installation

Clone the repository:

```bash
git clone https://github.com/nouranagiy/newsly-flutter.git
```

Navigate to the project:

```bash
cd newsly-flutter
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## Firebase Setup

1. Create a Firebase project, enable **Email/Password** in Authentication.
2. Place `android/app/google-services.json` (already in repo for this project) and ensure `lib/firebase_options.dart` matches (`flutterfire configure` regenerates it).
3. Deploy Firestore rules: `firebase deploy --only firestore:rules` (or paste `firestore.rules` in the console).
4. `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` is called in `lib/main.dart` before `runApp`.

## Testing

Unit/widget coverage (`test/widget_test.dart`) — `flutter test` (4 tests):
* Renders personalized feed
* Hides disliked articles
* Toggles light/dark theme from Profile
* Switches interface language to Arabic

Manual coverage:
* API data fetching, JSON parsing, loading/error/retry
* Search, category filtering (14 categories), For You / Top Stories, pull-to-refresh
* News details, article stats, local caching, offline mode, responsive UI
* Auth flow (sign up/in/out, `AuthGate` routing, onboarding edit), save/like/dislike persistence

## Author

**Nora Nagiy**

Flutter Developer
