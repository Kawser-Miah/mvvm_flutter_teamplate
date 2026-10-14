abstract final class ApiEndpoints {
  /// Set per environment: `flutter run --dart-define=BASE_URL=https://...`.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com/api/v1/',
  );

  /// Authentication
  static const String login = 'auth/signin/';
  static const String register = 'auth/register/';
  static const String refreshToken = 'auth/refresh-token/';

  /// Quotes (demo feature)
  static const String quotes = 'quotes/';

  /// Public endpoints: no Authorization header, no 401 refresh.
  static const List<String> noAuthEndpoints = [login, register, refreshToken];

  /// `https://host:port/api/v1/` → `wss://host:port` (http → ws).
  static String get wsBaseUrl {
    final uri = Uri.parse(baseUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final portStr = uri.hasPort ? ':${uri.port}' : '';
    return '$wsScheme://${uri.host}$portStr';
  }

  /// e.g. `wsUrl('ws/notifications/', token)`.
  static String wsUrl(String path, String token) =>
      '$wsBaseUrl/$path?token=${Uri.encodeComponent(token)}';
}
