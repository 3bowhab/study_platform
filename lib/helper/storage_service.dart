import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyAccessToken = "access_token";
  static const String _keyRefreshToken = "refresh_token";
  static const String _keyIsLoggedIn = "isLoggedIn";
  static const String _keyFullName = "full_name";
  static const String _keyEmail = "email";
  static const String _keyUserType = "user_type";
  static const String _keySeenOnboarding = "seen_onboarding"; // 👈 جديد

  /// حفظ التوكنات وبيانات تانيه
  Future<void> saveTokens(
    String access,
    String refresh,
    String fullName,
    String email,
    String userType,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, access);
    await prefs.setString(_keyRefreshToken, refresh);
    await prefs.setString(_keyFullName, fullName);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyUserType, userType);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// تحديث الـ Access Token بس
  Future<void> resetTokens(String access) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, access);
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
    await prefs.remove(_keyFullName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyUserType);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  /// قراءة الاسم الكامل
  Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFullName);
  }

  /// قراءة البريد الإلكتروني
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  /// قراءة نوع المستخدم
  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserType);
  }
  
  /// هل شاف الـ Onboarding قبل كده؟
  Future<bool> getSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySeenOnboarding) ?? false;
  }

  /// حفظ ان اليوزر شاف الـ Onboarding
  Future<void> setSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySeenOnboarding, value);
  }
}
