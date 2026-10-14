import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/register_view.dart';
import '../../features/design_system/views/design_system_view.dart';
import '../../features/quote/views/quote_list_view.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.quotes,
    routes: [
      GoRoute(
        path: RouteNames.quotes,
        builder: (context, state) => const QuoteListView(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: RouteNames.designSystem,
        builder: (context, state) => const DesignSystemView(),
      ),
    ],
  );
});
