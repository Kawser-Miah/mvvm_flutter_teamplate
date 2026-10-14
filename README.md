# Guard Well

A modern, robust Flutter application engineered with **MVVM (Model-View-ViewModel)** architecture, powered by **Riverpod** state management, centralized **GoRouter** navigation, and responsive scaling via **ScreenUtil**.

---

## 🏛️ Architecture Overview

The project adheres strictly to **MVVM Architecture** with feature-based modular packaging:

- **Model:** Independent data models and JSON serialization (organized under `lib/model/`).
- **View:** UI screens (`lib/features/<feature>/views/`) that listen to state with Riverpod `ConsumerWidget` and forward user interactions to the ViewModel.
- **ViewModel:** Presentation logic and state holders (`lib/features/<feature>/viewmodels/`) built with Riverpod `Notifier` or `AsyncNotifier`, decoupled from widget layout.
- **Repository & Service:** Abstract data access layers and network clients (Dio) handling remote APIs and local storage.
- **Centralized Router:** Route definitions in `lib/core/router/route_names.dart` managed by a single GoRouter instance in `lib/core/router/app_router.dart`.
- **Core Design System:** Reusable components, design tokens, and utilities stored in `lib/core/widgets/` and `lib/core/theme/`.

---

## 📁 Directory Structure

```text
lib/
├── app.dart                                # Application root with ScreenUtilInit & MaterialApp.router
├── main.dart                               # Entry point with ProviderScope
├── core/
│   ├── constants/                          # Global constants (dimensions, app strings)
│   ├── errors/                             # Custom failure & exception models
│   ├── extensions/                         # Dart & Flutter extension methods
│   ├── network/                            # Dio HTTP client & API endpoints
│   ├── router/                             # GoRouter configuration & RouteNames
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   ├── theme/                              # Application color palettes & typography tokens
│   ├── utils/                              # Custom SVG renderer, SnackBars, loggers, formatters
│   └── widgets/                            # Reusable application-wide components
│       ├── custom_button.dart              # Primary & secondary gradient pill buttons
│       ├── custom_text_field.dart          # Rounded inputs with password toggle & validation
│       ├── custom_checkbox.dart            # Animated interactive checkbox
│       ├── custom_drop_down.dart           # Expandable dropdown selector
│       ├── star_rating_row.dart            # 5-star interactive rating row
│       ├── billing_badge.dart              # Status & category pill badges
│       ├── custom_app_bar.dart             # Themed top app bar with BackPill
│       ├── back_pill.dart                  # Navigation back button pill
│       ├── overlay_confirmation.dart       # Modal confirmation dialog
│       ├── base_review_dialog.dart         # Review & feedback dialog
│       └── app_loader.dart / custom_loading.dart
├── model/                                  # Data entities grouped by domain
│   ├── auth/                               # User, login, & auth models
│   ├── quote/                              # Quote entity & API response models
│   └── rating/                             # App review & rating models
└── features/                               # Modular features
    ├── auth/                               # Authentication (Login, Register)
    │   ├── views/
    │   ├── viewmodels/
    │   ├── repositories/
    │   └── services/
    ├── quote/                              # Quotes showcase & management
    │   ├── views/
    │   ├── viewmodels/
    │   ├── repositories/
    │   └── services/
    └── design_system/                      # Interactive Design System component gallery
        ├── views/
        │   └── design_system_view.dart     # Showcase screen with live event logs & tabs
        ├── viewmodels/
        │   └── design_system_viewmodel.dart# State manager for interactive component testing
        └── widgets/                        # Section showcases (Buttons, Inputs, Selectors, Feedback)
```

---

## 🎨 Interactive Design System Gallery

The project includes an in-app **Design System Showcase** (`/design-system`) for testing, previewing, and debugging all reusable UI components with real-time feedback:

- **Buttons:** Primary gradient pills, secondary outlines, loading spinner states, and disabled states.
- **Inputs:** Text fields with hints, required indicators, interactive password eye toggle, error messaging, and country code selector.
- **Selectors:** Expandable dropdown menus, interactive 5-star ratings, animated checkboxes, and status badges.
- **Modals & Feedback:** `OverlayConfirmation` dialogs, `BaseReviewDialog` feedback forms, and styled `AppSnackBar` toasts (Success, Error, Warning, Info).
- **Live Event Log:** An on-screen console logging interactions in real time.

> **Accessing the Showcase:** Tap the palette icon (`🎨`) in the top app bar of the home screen, or navigate directly to `RouteNames.designSystem`.

---

## 🛠️ Tech Stack & Dependencies

- **Framework:** [Flutter](https://flutter.dev/) (Channel stable)
- **State Management:** [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod)
- **Routing:** [`go_router`](https://pub.dev/packages/go_router)
- **Networking:** [`dio`](https://pub.dev/packages/dio)
- **Responsive Layout:** [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil)
- **Vector Graphics:** [`flutter_svg`](https://pub.dev/packages/flutter_svg)
- **Image Caching:** [`cached_network_image`](https://pub.dev/packages/cached_network_image)
- **Local Storage:** [`shared_preferences`](https://pub.dev/packages/shared_preferences)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.24+ recommended)
- Android Studio / VS Code with Flutter extensions
- Android device or emulator / iOS Simulator

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd guard_well
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Running Tests & Static Analysis

- **Run all unit & widget tests:**
  ```bash
  flutter test
  ```
- **Run Dart analyzer:**
  ```bash
  flutter analyze
  ```

---

## 💡 Windows Build Note

If developing on Windows where your Flutter Pub cache and project directory are on different drives (e.g. `C:` cache and `D:` project), Kotlin incremental compilation is safely disabled via:
```properties
# android/gradle.properties
kotlin.incremental=false
```
This prevents Kotlin compiler path root mismatch exceptions during Android builds.

---

## 📄 License

This project is proprietary and confidential.
