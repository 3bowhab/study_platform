import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyToken = "token";
  static const String _keyIsLoggedIn = "isLoggedIn";

  /// حفظ التوكن
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// قراءة التوكن
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// هل المستخدم مسجل دخول؟
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// تسجيل الخروج (مسح البيانات)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
