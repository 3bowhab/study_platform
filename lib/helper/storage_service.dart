import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyAccessToken = "access_token";
  static const String _keyRefreshToken = "refresh_token";
  static const String _keyIsLoggedIn = "isLoggedIn";

  /// حفظ التوكنات
  Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, access);
    await prefs.setString(_keyRefreshToken, refresh);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// قراءة الـ Access Token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  /// قراءة الـ Refresh Token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  /// هل المستخدم مسجل دخول؟
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// تسجيل الخروج (مسح البيانات)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
