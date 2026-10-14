import 'package:guard_well/core/services/secure_storage_service/secure_storage_service.dart';

/// In-memory [SecureStorageService]. Unit tests use this instead of
/// FlutterSecureStorage, whose platform channel hangs forever in tests unless
/// `FlutterSecureStorage.setMockInitialValues({})` is called.
class FakeSecureStorageService implements SecureStorageService {
  final Map<SecureKey, String> values = {};

  @override
  Future<void> write(String value, SecureKey key) async => values[key] = value;

  @override
  Future<String?> read(SecureKey key) async => values[key];

  @override
  Future<void> delete(SecureKey key) async => values.remove(key);

  @override
  Future<void> clear() async => values.clear();
}
