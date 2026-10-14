import 'dart:developer' as developer;

abstract final class AppLogger {
  static void log(String message, {String name = 'GuardWell', Object? error}) {
    developer.log(message, name: name, error: error);
  }
}
