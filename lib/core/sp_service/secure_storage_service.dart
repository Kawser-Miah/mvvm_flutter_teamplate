import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<String?> getAccessToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> saveAccessToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString(_refreshTokenKey, token);
  }

  Future<void> deleteTokens() async {
    final prefs = await _getPrefs();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }
}
