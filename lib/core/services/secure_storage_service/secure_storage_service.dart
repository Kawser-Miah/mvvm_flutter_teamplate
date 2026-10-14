import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageServiceImpl(ref.watch(flutterSecureStorageProvider));
});

/// Every value kept in the platform keystore. Tokens only; everything
/// non-secret goes through `SpService`.
enum SecureKey {
  accessToken('access_token'),
  refreshToken('refresh_token');

  const SecureKey(this.key);
  final String key;
}

abstract interface class SecureStorageService {
  Future<void> write(String value, SecureKey key);
  Future<String?> read(SecureKey key);
  Future<void> delete(SecureKey key);

  /// Sign-out: removes every [SecureKey].
  Future<void> clear();
}

class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String value, SecureKey key) =>
      _storage.write(key: key.key, value: value);

  @override
  Future<String?> read(SecureKey key) => _storage.read(key: key.key);

  @override
  Future<void> delete(SecureKey key) => _storage.delete(key: key.key);

  // Only our own keys: deleteAll() would also wipe entries written by plugins.
  @override
  Future<void> clear() async {
    for (final key in SecureKey.values) {
      await _storage.delete(key: key.key);
    }
  }
}
