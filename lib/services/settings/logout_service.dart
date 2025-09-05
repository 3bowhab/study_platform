import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';

class LogoutService {
  final Api api = Api();
  final StorageService storageService = StorageService();

  Future<void> logout() async {
    try {
      // 🟢 هات التوكين من الـ Storage
      final token = await storageService.getAccessToken();

      if (token == null) {
        throw Exception("No token found, user might not be logged in.");
      }

      // ✨ ننده API ونبعت التوكين
      final response = await api.post(
        url: ApiConstants.logout,
        body: {}, // مفيش باراميترز
        token: token,
      );

      print("✅ Logout successful: $response");

      // 🧹 امسح التوكينات من التخزين
      await storageService.logout();
    } catch (e) {
      print("❌ Error during logout: $e");
      rethrow;
    }
  }
}
