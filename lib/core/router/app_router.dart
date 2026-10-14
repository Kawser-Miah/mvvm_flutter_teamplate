import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/register_view.dart';
import '../../features/design_system/views/design_system_view.dart';
import '../../features/quote/views/quote_list_view.dart';
import 'pages.dart';

export 'pages.dart';

/// The single [GoRouter]. No auth redirect: the session is restored in
/// `main()` before `runApp`, [initialLocation] is chosen once from it, and
/// login / register / logout navigate explicitly with `context.go(...)`.
final appRouterProvider = Provider<GoRouter>((ref) {
  final signedIn = ref.watch(signedInAtLaunchProvider);
  final router = GoRouter(
    initialLocation:
        signedIn ? PAGES.home.screenPath : PAGES.login.screenPath,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: PAGES.home.screenPath,
        name: PAGES.home.screenName,
        builder: (context, state) => const QuoteListView(),
      ),
      GoRoute(
        path: PAGES.login.screenPath,
        name: PAGES.login.screenName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: PAGES.register.screenPath,
        name: PAGES.register.screenName,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: PAGES.designSystem.screenPath,
        name: PAGES.designSystem.screenName,
        builder: (context, state) => const DesignSystemView(),
      ),
    ],
  );
  AppRouter._router = router;
  ref.onDispose(router.dispose);
  return router;
});

/// Context-free navigation (e.g. from a service): `AppRouter.router.go(...)`.
abstract final class AppRouter {
  static GoRouter? _router;

  static GoRouter get router =>
      _router ??
      (throw StateError('AppRouter.router used before appRouterProvider was read.'));
}
