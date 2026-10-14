# Flutter MVVM Architecture Template

A modern, production-ready Flutter starter template engineered with **MVVM (Model-View-ViewModel)** architecture, powered by **Riverpod** state management, centralized **GoRouter** navigation, an in-app **Design System Component Gallery**, and responsive layout scaling via **ScreenUtil**.

---

## 🏛️ Architecture Overview

The project follows **MVVM** with feature-based packaging:

- **Model:** data models with `fromJson`/`toJson` (`lib/model/`).
- **View:** screens (`lib/features/<feature>/views/`) built as Riverpod `ConsumerWidget`s. They forward user actions to the ViewModel.
- **ViewModel:** `Notifier`/`AsyncNotifier` state holders (`lib/features/<feature>/viewmodels/`).
- **Repository:** `<feature>_repository.dart` (+ `_impl` when it has real logic). Returns `Result<T>` and never throws.
- **Data source:** Retrofit clients in `data_sources/`. Each method returns `Future<Result<T>>` through `ResultCallAdapter`.
- **Providers:** plain Riverpod `Provider`s wire everything (`lib/features/<feature>/providers/`, plus a provider next to each core service).

```
View ─ref.watch/read→ ViewModel ─→ Repository ─→ RemoteDataSource (Retrofit + ResultCallAdapter) ─→ Dio
                                        └─→ SpService / SecureStorageService
```

---

## 📁 Directory Structure

```text
lib/
├── main.dart                     # prefs + session restore, then runApp(ProviderScope(overrides: …))
├── app.dart                      # ScreenUtilInit + MaterialApp.router
├── core/
│   ├── constants/                # app_constants, app_icons, app_images, app_texts
│   ├── controllers/              # theme_controller, localization_controller (use SpService)
│   ├── errors/                   # result.dart (Result<T>, ErrorKind), app_exception.dart
│   ├── extensions/
│   ├── router/
│   │   ├── pages.dart            # PAGES enum: path + name of every route
│   │   └── app_router.dart       # appRouterProvider, AppRouter.router
│   ├── services/                 # ← every infrastructure service lives here
│   │   ├── network/
│   │   │   ├── api_endpoints.dart
│   │   │   ├── api_error_handler.dart   # the ONE DioException → message mapper
│   │   │   ├── api_interceptor.dart     # Bearer token + shared 401 refresh/retry
│   │   │   ├── dio_client.dart
│   │   │   ├── repo_guard.dart          # guard(): the one place errors become Failure
│   │   │   ├── result_call_adapter.dart # Retrofit adapter → guard()
│   │   │   └── websocket/
│   │   │       ├── websocket_client.dart
│   │   │       └── websocket_token_helper.dart
│   │   ├── sp_service/sp_service.dart
│   │   └── secure_storage_service/secure_storage_service.dart
│   ├── theme/                    # app_colors (single source), app_theme, text styles
│   ├── utils/                    # pure helpers only: formatter, app_logger, validators
│   └── widgets/                  # reusable widgets (buttons, fields, snackbar, svg, image picker…)
├── model/                        # auth/, quote/, common/
└── features/
    ├── auth/      {data_sources, repositories, providers, viewmodels, views, widgets}
    ├── quote/     {data_sources, repositories, providers, viewmodels, views, widgets}
    └── design_system/            # component gallery (demo)
```

---

## 💾 Local storage

### `SpService`: the only gateway to SharedPreferences

App code never touches `SharedPreferences` directly. The instance is created **once** in `main()` and injected with `sharedPreferencesProvider.overrideWithValue(prefs)`.

```dart
enum StorageKey {
  themeIsDark('theme_is_dark'), // the stored string is explicit, so renaming
  languageCode('language_code'), // a member never orphans saved data
  countryCode('country_code'),
  user('user_json');
  …
}

final sp = ref.read(spServiceProvider);
await sp.write(true, StorageKey.themeIsDark);     // int | double | bool | String, else ArgumentError
final isDark = sp.read<bool>(StorageKey.themeIsDark); // synchronous; null if missing OR wrong type
await sp.writeList(['a'], StorageKey.user);
await sp.delete(StorageKey.languageCode);
```

Add a key by adding an enum member. Keep the enum to generic template keys.

### `SecureStorageService`: tokens only

Backed by `flutter_secure_storage` (Keychain / Android Keystore). Non-secret data (cached user, settings) goes to `SpService`.

```dart
final secure = ref.read(secureStorageServiceProvider);
await secure.write(token, SecureKey.accessToken);
final token = await secure.read(SecureKey.accessToken);
await secure.clear(); // sign-out: removes every SecureKey
```

> **Android minSdk 24.** `flutter_secure_storage` 11.x requires API 24+, pinned in `android/app/build.gradle.kts` (`minSdk = maxOf(flutter.minSdkVersion, 24)`).

---

## 🌐 Network

### `Result<T>` + `ResultCallAdapter`: no try/catch in data sources or repositories

```dart
@RestApi(callAdapter: ResultCallAdapter) // ← class level!
abstract class QuoteRemoteDataSource {
  factory QuoteRemoteDataSource(Dio dio, {String? baseUrl}) = _QuoteRemoteDataSource;

  @GET(ApiEndpoints.quotes)
  Future<Result<List<QuoteModel>>> getQuotes();
}
```

> ⚠️ **Gotcha:** declare the adapter with `@RestApi(callAdapter: …)`. A class-level `@UseCallAdapter(…)` is **ignored** by `retrofit_generator`, which then generates a call to a non-existent `Result.fromJson`.

`ResultCallAdapter.adapt` is just `guard(() async => Result.success(await call()), fallback: …)`. Repositories use the same `guard()` for non-HTTP work (storage, parsing, token checks), so errors are mapped in exactly one place:

```dart
Future<Result<void>> logout() => guard(() async {
      await _secureStorage.clear();
      await _sp.delete(StorageKey.user);
      return const Result.success(null);
    }, fallback: 'Could not sign out. Please try again.');
```

`guard()` always `debugPrint`s the real error and **never** puts raw exception text into the message.

| Cause | `Failure.kind` | `statusCode` | `message` |
|---|---|---|---|
| no connection / DNS | `network` | – | "No internet connection…" |
| connect/send/receive timeout | `network` | – | "Request timeout…" |
| HTTP 401 (after refresh failed) | `unauthorized` | 401 | server message or "Session expired…" |
| other non-2xx | `server` | code | server `message`/`error`/`detail`/field errors, else a per-code default |
| anything else (parsing, storage, bugs) | `unknown` | – | the caller's `fallback` |

Branch with `failure.isNetworkError` / `failure.isUnauthorized`. In view-models, `result.getOrThrow()` inside `AsyncValue.guard` turns a `Failure` into an `AppException` whose `toString()` is the friendly message.

**Auth rule:** a 2xx login/register response **without a token is rejected** (`'Invalid response from server.'`). Tokens (secure storage) and the user (SpService) are persisted only after that check. Expected body (adjust `AuthResponseModel.fromJson` to your backend):

```json
{ "token": "<access>", "refresh_token": "<refresh, optional>", "user": { "id": "1", "email": "a@b.co", "name": "Ann" } }
```

### Dio client

- Base URL from a define: `flutter run --dart-define=BASE_URL=https://api.myapp.com/api/v1/` (default `https://api.example.com/api/v1/`).
- Interceptors: `ApiInterceptor` (Bearer token, 401 → one shared refresh via a `Completer`, then retry), then `PrettyDioLogger` **only in debug**.
- `ApiEndpoints` holds only the endpoints the template uses; `noAuthEndpoints` skips the auth header.

### WebSocket

`WebSocketClient` is a generic JSON socket: 30s ping, exponential-backoff reconnect (max 30s), token refresh on close code `4001`, broadcast `stream`. Wrap it in a feature service:

```dart
final tokens = WebSocketTokenHelper(ref.read(secureStorageServiceProvider));
final client = WebSocketClient(
  debugName: 'Notifications',
  urlBuilder: () async {
    final token = await tokens.getAccessToken();
    return token == null ? null : ApiEndpoints.wsUrl('ws/notifications/', token);
  },
  onRefreshToken: tokens.refreshAccessToken,
);
await client.connect();
client.stream.listen(handleEvent);
// dispose: client.dispose();
```

`ApiEndpoints.wsBaseUrl` derives `ws://`/`wss://` from `BASE_URL`.

---

## 🧭 Routing

All routes live in one enum. Path and name are required, so a page can't exist without both:

```dart
enum PAGES {
  home('/', 'HOME'),
  login('/login', 'LOGIN'),
  register('/register', 'REGISTER'),
  designSystem('/design-system', 'DESIGN_SYSTEM');
  …
}

GoRoute(path: PAGES.home.screenPath, name: PAGES.home.screenName, builder: …)
context.go(PAGES.login.screenPath);   // never raw strings
AppRouter.router.go(…);               // context-free
```

- **No auth redirect / `refreshListenable`.** `main()` reads the access token before `runApp` and overrides `signedInAtLaunchProvider`. The router picks `initialLocation` once (home if signed in, else login). Login, register and logout navigate explicitly with `context.go(…)`.
- **Typed arguments.** Put IDs in path params (`/item/:id`) so they survive deep links. Pass anything else as a typed args class and guard the cast at the boundary:
  ```dart
  builder: (context, state) {
    final args = state.extra;
    if (args is! ItemArgs) return const NotFoundView();
    return ItemView(args: args);
  }
  ```
- `debugLogDiagnostics` is on only in `kDebugMode`.

> ⚠️ **Temporary login bypass (active).** The **Sign In** button currently skips validation and the API and calls `context.go(PAGES.home.screenPath)` directly, so you can reach the app without a backend. Because no token is saved, a cold start always opens on Login, and the quotes list on home shows an error with Retry unless `BASE_URL` points at a real API.
>
> **To re-enable real sign-in:** in `lib/features/auth/widgets/login_form.dart`, `_onLogin()`, delete the `context.go(...)` line and uncomment the block below it (form validation + `loginViewModelProvider.notifier.login(...)`). `LoginView` already navigates to home when the login succeeds.

---

## ➕ Adding a feature (MVVM + Riverpod)

1. **Model:** `lib/model/<feature>/x_model.dart` with `fromJson`/`toJson`.
2. **Endpoint:** add the path to `ApiEndpoints`.
3. **Data source:** `features/<feature>/data_sources/x_remote_data_source.dart` with `@RestApi(callAdapter: ResultCallAdapter)` and methods returning `Future<Result<T>>`. Run build_runner.
4. **Repository:** `x_repository.dart` (+ `_impl`). Return `Result<T>`; wrap any non-HTTP work in `guard(…, fallback: '…')`. No try/catch.
5. **Providers:** `features/<feature>/providers/x_providers.dart`:
   ```dart
   final xRemoteDataSourceProvider = Provider((ref) => XRemoteDataSource(ref.watch(dioClientProvider).dio));
   final xRepositoryProvider = Provider((ref) => XRepository(ref.watch(xRemoteDataSourceProvider)));
   ```
6. **ViewModel:** `AsyncNotifier<T>`; `state = await AsyncValue.guard(() async => (await repo.getX()).getOrThrow());`
7. **View:** `ConsumerWidget` that renders `loading` / `error` / empty / data, validates forms with `Validators`.
8. **Route:** add a `PAGES` member and a `GoRoute`.
9. **Tests:** repository test (mocktail data source + fakes), view-model/provider test, and add the new providers to `test/providers_smoke_test.dart`.

---

## ✅ Quality gates

```bash
dart run build_runner build --delete-conflicting-outputs   # after any @RestApi / codegen change
flutter analyze                                            # zero issues
flutter test                                               # all green
```

`analysis_options.yaml` excludes generated files and enables `avoid_print`, `prefer_const_constructors`, `prefer_const_declarations`, `unawaited_futures`, `cancel_subscriptions` and `close_sinks`.

### Test mocks

- **SharedPreferences:** `SharedPreferences.setMockInitialValues({})`, then override `sharedPreferencesProvider`.
- **Secure storage:** any test that reaches `FlutterSecureStorage` **must** call `FlutterSecureStorage.setMockInitialValues({})`, or it hangs forever on the platform channel. Unit tests should prefer `test/helpers/fake_secure_storage_service.dart`.
- **Network:** mock the Retrofit data source with `mocktail` and return `Result.success(…)` / `Result.error(…)`.
- If a run seems stuck, run files one by one with `flutter test <file> --timeout 30s` to find the culprit (almost always secure storage).

---

## 🎨 Interactive Design System Gallery

The project includes an in-app **Design System Showcase** (`/design-system`) for testing, previewing, and debugging all reusable UI components with real-time feedback:

- **Buttons:** Primary gradient pills, secondary outlines, loading spinner states, and disabled states.
- **Inputs:** Text fields with hints, required indicators, interactive password eye toggle, error messaging, and country code selector.
- **Selectors:** Expandable dropdown menus, interactive 5-star ratings, animated checkboxes, and status badges.
- **Modals & Feedback:** `OverlayConfirmation` dialogs, `BaseReviewDialog` feedback forms, and styled `AppSnackBar` toasts (Success, Error, Warning, Info).
- **Live Event Log:** An on-screen console logging interactions in real time.

> **Accessing the Showcase:** Tap the palette icon (`🎨`) in the top app bar of the home screen, or navigate to `PAGES.designSystem`.

---

## 🛠️ Tech Stack & Dependencies

- **Framework:** [Flutter](https://flutter.dev/) (Channel stable)
- **State Management:** [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod)
- **Routing:** [`go_router`](https://pub.dev/packages/go_router)
- **Networking:** [`dio`](https://pub.dev/packages/dio) & [`retrofit`](https://pub.dev/packages/retrofit)
- **WebSockets:** [`web_socket_channel`](https://pub.dev/packages/web_socket_channel)
- **Responsive Layout:** [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil)
- **Vector Graphics:** [`flutter_svg`](https://pub.dev/packages/flutter_svg)
- **Image Caching:** [`cached_network_image`](https://pub.dev/packages/cached_network_image)
- **Local Storage:** [`shared_preferences`](https://pub.dev/packages/shared_preferences) & [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)
- **Logging:** [`pretty_dio_logger`](https://pub.dev/packages/pretty_dio_logger) (debug only)
- **Testing:** [`mocktail`](https://pub.dev/packages/mocktail)
- **Code Generation:** [`build_runner`](https://pub.dev/packages/build_runner) & [`retrofit_generator`](https://pub.dev/packages/retrofit_generator)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.24+ recommended)
- Android Studio / VS Code with Flutter extensions
- Android device or emulator / iOS Simulator

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Kawser-Miah/mvvm_flutter_teamplate.git
   cd mvvm_flutter_teamplate
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app** (point it at your backend):
   ```bash
   flutter run --dart-define=BASE_URL=https://api.myapp.com/api/v1/
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

This template is open-source and available under the [MIT License](LICENSE).
