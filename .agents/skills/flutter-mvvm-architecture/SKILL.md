---
name: flutter-mvvm-architecture
description: MVVM architecture guidelines for Flutter development in this project, using Riverpod for state management, feature-based modular folder structure, centralized App Router, ScreenUtil responsive sizing, and reusable UI components.
---

# Flutter Development Skill — MVVM Architecture

## 1. Project Architecture

Follow **MVVM (Model–View–ViewModel)** architecture for all Flutter development in this project.

Use a feature-based folder structure. Each feature must keep its own models, views, ViewModels, repositories, services, and other related files inside its specific folder.

### Core Rules

- Use MVVM architecture consistently.
- Use Riverpod for state management.
- Use a centralized App Router for navigation.
- Keep features modular and independent.
- Reuse common UI components, colors, typography, and utilities.
- Use responsive layouts with ScreenUtil.
- Use SafeArea where appropriate to prevent content from overlapping system UI.
- Avoid unnecessary abstraction and duplication.
- Follow clean code principles and maintain existing project conventions.

## 2. Folder Structure

Organize the project using the following structure:

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── api_endpoints.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_theme.dart
│   │   └── app_dimensions.dart
│   ├── utils/
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── app_loader.dart
│       └── app_app_bar.dart
│
├── model/
│   ├── auth/
│   │   ├── user_model.dart
│   │   ├── login_request_model.dart
│   │   └── auth_response_model.dart
│   └── quote/
│       ├── quote_model.dart
│       └── quote_response_model.dart
│
├── features/
│   ├── auth/
│   │   ├── views/
│   │   │   ├── login_view.dart
│   │   │   └── register_view.dart
│   │   ├── viewmodels/
│   │   │   ├── login_viewmodel.dart
│   │   │   └── register_viewmodel.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   └── auth_repository_impl.dart
│   │   ├── data_sources/
│   │   │   ├── auth_remote_data_source.dart
│   │   │   └── auth_remote_data_source.g.dart
│   │   ├── providers/
│   │   │   └── auth_providers.dart
│   │   └── widgets/
│   │       └── login_form.dart
│   │
│   └── quote/
│       ├── views/
│       │   └── quote_list_view.dart
│       ├── viewmodels/
│       │   └── quote_viewmodel.dart
│       ├── repositories/
│       │   └── quote_repository.dart
│       ├── services/
│       │   └── quote_api_service.dart
│       ├── providers/
│       │   └── quote_providers.dart
│       └── widgets/
│           └── quote_card.dart
│
├── app.dart
└── main.dart
```

### Folder Responsibilities

- `core/`: Application-wide utilities, networking, routing, theme, constants, and reusable components.
- `model/`: Shared data models organized by feature or domain. Never place all model classes directly inside one flat folder.
- `features/`: Feature-specific UI, ViewModels, repositories, data sources / services, providers, and widgets.
- `views/`: Screens and UI composition.
- `viewmodels/`: Presentation logic, UI state, input handling, and interactions with repositories.
- `repositories/`: Data access coordination. Use abstract contract (`<feature>_repository.dart`) and concrete implementation (`<feature>_repository_impl.dart`).
- `data_sources/` (or `services/`): API requests (Retrofit/Dio) and external or local data source integrations.
- `providers/`: Riverpod provider declarations when they are kept separate from ViewModel files.
- `widgets/`: Components specific to a feature.
- `core/widgets/`: Reusable components shared across multiple features.

**Important:** The `model/` directory is reserved for model files organized into feature-specific subfolders. Do not put every model in a single directory. Keep unrelated concerns in their respective directories.

For larger projects, feature-specific models may instead live inside each feature folder. Follow the existing project convention and do not mix organizational approaches unnecessarily.

## 3. MVVM Responsibilities

### Model

- Define data structures and model classes.
- Parse JSON responses into Dart objects.
- Serialize request models when needed.
- Keep models independent of Flutter UI widgets.
- Organize models by feature.

### View

- Build the screen UI.
- Read state exposed by Riverpod.
- Forward user interactions to the ViewModel.
- Display loading, success, empty, and error states.
- Use shared components and theme resources.
- Do not implement API calls or complex business logic directly inside widgets.

### ViewModel

- Manage presentation state.
- Handle user interactions.
- Perform presentation-level validation.
- Call repository methods.
- Handle asynchronous operations and expose UI-friendly errors.
- Update state through Riverpod.
- Keep widget layout and HTTP implementation out of the ViewModel.

### Repository

- Coordinate access to remote APIs, local databases, and caches.
- Return typed model objects.
- Encapsulate data source selection and data access.
- Keep UI widgets independent of implementation details.

### Service

- Implement API requests and external integrations.
- Configure request parameters, headers, and response handling.
- Use the project's established network client.
- Avoid duplicating networking configuration across features.

## 4. Riverpod State Management

Use **flutter_riverpod** as the standard state management solution.

### Rules

- Use `ConsumerWidget` or `ConsumerStatefulWidget` when a widget needs Riverpod.
- Use `ref.watch()` to observe state.
- Use `ref.read()` for actions, such as invoking a ViewModel method.
- Prefer `Notifier` or `AsyncNotifier` for new state management implementations where appropriate.
- Use `AsyncValue` or an equivalent explicit state representation for asynchronous operations.
- Represent loading, success, empty, and error states clearly.
- Keep provider declarations and ViewModel logic organized by feature.
- Use dependency injection through Riverpod providers when appropriate.
- Avoid unnecessary global mutable state.
- Do not use `setState` as a replacement for Riverpod-managed application state. Local, temporary widget-only state may use `setState` when appropriate.
- Follow the Riverpod version already configured in `pubspec.yaml`.

### Example

```dart
final quoteViewModelProvider =
    AsyncNotifierProvider<QuoteViewModel, List<QuoteModel>>(
  QuoteViewModel.new,
);

class QuoteViewModel extends AsyncNotifier<List<QuoteModel>> {
  @override
  Future<List<QuoteModel>> build() async {
    final repository = ref.read(quoteRepositoryProvider);
    return repository.getQuotes();
  }

  Future<void> refreshQuotes() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(quoteRepositoryProvider);
      return repository.getQuotes();
    });
  }
}
```

Treat this as a structural example. Ensure `QuoteModel` and `quoteRepositoryProvider` are defined and imported correctly. For refresh operations, preserve existing data during loading when the UI requires it rather than always replacing the state with a loading-only state.

## 5. Centralized App Router

Use a centralized router for all application navigation.

### Rules

- Keep route definitions in `core/router/`.
- Use the router package already established in the project, preferably GoRouter if no router has been selected.
- Avoid scattered navigation logic and duplicated route strings.
- Define route names and paths centrally when useful.
- Support nested navigation and authentication redirects through router configuration when required.
- Pass required route parameters using typed or clearly validated mechanisms.
- Do not place route configuration inside ViewModels.
- ViewModels may expose navigation-relevant outcomes, but the View or a dedicated navigation coordinator should perform navigation according to the project's established pattern.
- Do not create a second router or replace the existing navigation system without explicit approval.

## 6. Common App Colors

Keep application-wide colors inside:

`lib/core/theme/app_colors.dart`

### Rules

- Use centralized color definitions instead of scattering raw color values throughout the application.
- Use semantic color names such as `primary`, `background`, `surface`, `textPrimary`, `textSecondary`, `success`, and `error`.
- Support light and dark themes when required.
- Avoid duplicate color definitions across features.
- Prefer theme-aware colors when a component needs to adapt to the active theme.

Example:

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
}
```

The example uses static constants as immutable design tokens. This is intentional and does not conflict with the requirement to avoid static methods or mutable static state for application behavior.

## 7. Common Font Styles

Keep reusable typography in:

`lib/core/theme/app_text_styles.dart`

### Rules

- Define reusable heading, title, body, caption, button, and label styles.
- Use the project's configured font family.
- Centralize font sizes, weights, and other repeated typography values.
- Apply ScreenUtil sizing consistently if the project uses it for text scaling.
- Prefer `Theme.of(context).textTheme` when the style needs to adapt dynamically to the active theme.

Example:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppTextStyles {
  static TextStyle get heading => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get body => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get caption => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      );
}
```

Do not hardcode repeated typography styles throughout screen widgets. Use the centralized styles or the active theme's text styles.

## 8. Reusable Custom Components

Keep application-wide reusable components inside:

`lib/core/widgets/`

Examples include:

- `AppButton`
- `AppTextField`
- `AppAppBar`
- `AppLoader`
- `AppErrorWidget`
- `AppEmptyState`
- `AppNetworkImage`
- `AppDialog`

### Rules

- Reuse existing components before creating new ones.
- Use consistent naming with the `App` prefix for shared application components.
- Make components configurable through constructor parameters.
- Follow the application's common colors, typography, spacing, and sizing rules.
- Keep reusable components independent of individual feature ViewModels unless dependency injection is deliberately part of the design.
- Place feature-specific components inside the corresponding feature's `widgets/` directory.
- Avoid duplicating the same UI component in multiple features.

## 9. SafeArea

Use `SafeArea` to prevent screen content from being obscured by system UI.

### Rules

- Use `SafeArea` on screens where content can extend beneath the status bar, navigation bar, or device cutouts.
- Consider wrapping the main screen body in `SafeArea`.
- Do not add redundant nested `SafeArea` widgets without a reason.
- Account for keyboard insets on form screens.
- Use `Scaffold` and system inset behavior consistently.
- Do not apply SafeArea blindly to intentional edge-to-edge backgrounds, images, or app bars. Protect foreground content while preserving the intended design.

Example:

```dart
Scaffold(
  body: SafeArea(
    child: YourScreenContent(),
  ),
);
```

## 10. ScreenUtil and Responsive UI

Use `flutter_screenutil` for responsive sizing when it is configured in the project.

### Rules

- Initialize `ScreenUtil` at the application root before using its extensions.
- Follow the project's existing design dimensions.
- Use `.w` for width-based sizing, `.h` for height-based sizing, `.r` for radii, and `.sp` for font sizing where appropriate.
- Use `.sw` and `.sh` for screen-relative measurements when appropriate.
- Avoid hardcoding dimensions repeatedly throughout screens.
- Prefer flexible layouts such as `Expanded`, `Flexible`, `Wrap`, and scrollable widgets when they provide better adaptability.
- Do not use ScreenUtil as a substitute for responsive layout design.
- Avoid applying scaling extensions inconsistently to the same category of values.
- Preserve accessibility, including support for system text scaling.

Example:

```dart
Container(
  padding: EdgeInsets.all(16.r),
  width: 200.w,
  child: Text(
    'Responsive content',
    style: AppTextStyles.body,
  ),
);
```

Ensure `ScreenUtilInit` is configured in the application entry point using the project's selected design size.

## 11. Naming Conventions

Follow these conventions:

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables and methods: `camelCase`
- Constants: descriptive names following the project's established convention
- Views: `login_view.dart`
- ViewModels: `login_viewmodel.dart`
- Models: `user_model.dart`
- Repositories: `auth_repository.dart` (abstract contract) and `auth_repository_impl.dart` (implementation)
- Data Sources: `auth_remote_data_source.dart` (Retrofit/Dio) / `auth_local_data_source.dart`
- Services: `auth_api_service.dart` / `quote_api_service.dart`
- Shared components: `app_button.dart`
- Providers: feature-specific, descriptive names

Keep names explicit and consistent throughout the codebase.

## 12. Dependency Injection

- Use the dependency injection system already configured in the project.
- Use Riverpod providers for dependencies where appropriate.
- Reuse configured Dio clients and repository instances.
- Avoid creating new service instances inside every widget build.
- Do not introduce another dependency injection framework without explicit approval.
- Keep dependency creation separate from presentation logic.

## 13. Error Handling and Async State

- Handle API and repository failures explicitly.
- Avoid swallowing exceptions without reporting a meaningful failure.
- Expose errors in a form the UI can display.
- Provide loading feedback for asynchronous operations.
- Handle empty results separately from errors.
- Avoid repeated API requests caused by unnecessary widget rebuilds.
- Follow the project's established logging and error-handling conventions.

## 14. Code Modification Rules

These rules are mandatory.

- Modify only the code relevant to the requested task.
- Do not change unrelated functions, widgets, files, or architecture.
- Do not refactor unrelated code while implementing a feature or fixing a bug.
- Preserve existing functionality and established project conventions.
- Reuse existing components, providers, services, and utilities whenever possible.
- Do not rename or move files unless explicitly requested or essential to the task.
- Do not replace an existing state management or routing solution without explicit approval.
- Do not add unnecessary packages.
- Before changing code, inspect the relevant files and their dependencies.
- If a requested change requires modifications outside the specified scope, explain why before proceeding when practical.
- Keep code changes focused, minimal, and easy to review.

## 15. Development Workflow

For every new feature or modification:

1. Inspect the existing project structure and relevant code.
2. Identify the feature, View, ViewModel, model, repository, and service involved.
3. Reuse existing theme tokens and custom components.
4. Implement or update the data layer as needed.
5. Implement presentation logic using Riverpod.
6. Build the UI using the project's reusable components, SafeArea, and ScreenUtil conventions.
7. Use the centralized router for navigation.
8. Handle loading, success, empty, and error states.
9. Run formatting and relevant analysis or tests when available.
10. Report the files changed and any issues that remain.

## 16. Final Architecture Principles

Every implementation must follow these principles:

- **MVVM:** Separate UI from presentation logic and data access.
- **Feature organization:** Group models and related code by feature rather than creating flat folders.
- **Riverpod:** Use a consistent, version-compatible state management approach.
- **Centralized navigation:** Keep route configuration in the App Router.
- **Design system:** Reuse app colors, typography, and custom components.
- **Responsive UI:** Use SafeArea and ScreenUtil appropriately.
- **Maintainability:** Prefer clear, testable, reusable code over unnecessary abstraction.
- **Scope control:** Never modify unrelated code without authorization.

When instructions conflict with existing code or dependencies, inspect the project first and preserve its working conventions unless the user explicitly requests a change.
