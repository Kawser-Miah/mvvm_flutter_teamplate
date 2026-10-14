import 'package:flutter_test/flutter_test.dart';
import 'package:guard_well/core/services/sp_service/sp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SpService sp;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sp = SpServiceImpl(await SharedPreferences.getInstance());
  });

  group('round-trip', () {
    test('int', () async {
      await sp.write(42, StorageKey.user);
      expect(sp.read<int>(StorageKey.user), 42);
    });

    test('double', () async {
      await sp.write(1.5, StorageKey.user);
      expect(sp.read<double>(StorageKey.user), 1.5);
    });

    test('bool', () async {
      await sp.write(false, StorageKey.themeIsDark);
      expect(sp.read<bool>(StorageKey.themeIsDark), isFalse);
    });

    test('String', () async {
      await sp.write('en', StorageKey.languageCode);
      expect(sp.read<String>(StorageKey.languageCode), 'en');
    });

    test('List<String>', () async {
      await sp.writeList(['a', 'b'], StorageKey.user);
      expect(sp.readList(StorageKey.user), ['a', 'b']);
    });
  });

  test('stores under the explicit key string', () async {
    await sp.write(true, StorageKey.themeIsDark);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('theme_is_dark'), isTrue);
  });

  test('missing key reads as null', () {
    expect(sp.read<String>(StorageKey.languageCode), isNull);
    expect(sp.readList(StorageKey.user), isNull);
    expect(sp.contains(StorageKey.languageCode), isFalse);
  });

  test('type mismatch reads back as null instead of throwing', () async {
    await sp.write('not a bool', StorageKey.themeIsDark);
    expect(sp.read<bool>(StorageKey.themeIsDark), isNull);
    expect(sp.readList(StorageKey.themeIsDark), isNull);
  });

  test('delete removes what write stored', () async {
    await sp.write('en', StorageKey.languageCode);
    expect(sp.contains(StorageKey.languageCode), isTrue);

    await sp.delete(StorageKey.languageCode);

    expect(sp.contains(StorageKey.languageCode), isFalse);
    expect(sp.read<String>(StorageKey.languageCode), isNull);
  });

  test('unsupported type throws ArgumentError', () {
    expect(
      () => sp.write(DateTime(2026), StorageKey.user),
      throwsArgumentError,
    );
  });
}
