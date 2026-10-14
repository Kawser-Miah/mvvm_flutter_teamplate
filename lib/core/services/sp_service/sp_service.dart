import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Created once in `main()` and injected with
/// `sharedPreferencesProvider.overrideWithValue(prefs)`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'Override sharedPreferencesProvider in ProviderScope (see main.dart).',
  );
});

final spServiceProvider = Provider<SpService>((ref) {
  return SpServiceImpl(ref.watch(sharedPreferencesProvider));
});

/// Every value kept in SharedPreferences. The stored string is explicit,
/// so renaming a member never orphans saved data.
enum StorageKey {
  themeIsDark('theme_is_dark'),
  languageCode('language_code'),
  countryCode('country_code'),
  user('user_json');

  const StorageKey(this.key);
  final String key;
}

/// The only gateway to SharedPreferences. Non-secret data only: tokens go
/// to `SecureStorageService`.
abstract interface class SpService {
  /// int, double, bool or String; anything else throws [ArgumentError].
  Future<void> write<T extends Object>(T value, StorageKey key);
  Future<void> writeList(List<String> value, StorageKey key);

  /// Synchronous (SharedPreferences is cached in memory) so notifiers can use
  /// it for initial state. Returns null when missing OR of a different type.
  T? read<T extends Object>(StorageKey key);
  List<String>? readList(StorageKey key);
  bool contains(StorageKey key);
  Future<void> delete(StorageKey key);
}

class SpServiceImpl implements SpService {
  SpServiceImpl(this._sp);
  final SharedPreferences _sp;

  @override
  Future<void> write<T extends Object>(T value, StorageKey key) async {
    switch (value) {
      case final int v:
        await _sp.setInt(key.key, v);
      case final double v:
        await _sp.setDouble(key.key, v);
      case final bool v:
        await _sp.setBool(key.key, v);
      case final String v:
        await _sp.setString(key.key, v);
      default:
        throw ArgumentError('Unsupported type: ${value.runtimeType}');
    }
  }

  @override
  Future<void> writeList(List<String> value, StorageKey key) =>
      _sp.setStringList(key.key, value);

  @override
  T? read<T extends Object>(StorageKey key) {
    final value = _sp.get(key.key);
    return value is T ? value : null;
  }

  @override
  List<String>? readList(StorageKey key) {
    final value = _sp.get(key.key);
    // getStringList would throw on a non-list value; mirror read<T>() instead.
    return value is List ? value.whereType<String>().toList() : null;
  }

  @override
  bool contains(StorageKey key) => _sp.containsKey(key.key);

  @override
  Future<void> delete(StorageKey key) => _sp.remove(key.key);
}
