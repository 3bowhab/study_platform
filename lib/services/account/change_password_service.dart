import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';

class ChangePasswordService {
  final Api api = Api();
  final StorageService storageService = StorageService();
  
  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String newPasswordConfirm,
  ) async {
    try {
      // 🟢 استدعاء التوكن من SharedPreferences
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await api.post(
        url: ApiConstants.changepassword,
        body: {
          "old_password": oldPassword,
          "new_password": newPassword,
          "new_password_confirm": newPasswordConfirm,
        },
        token: token, // ✅ هنا بعتنا التوكن
      );

      print("Response from API: $response");
    } catch (e) {
      throw Exception("❌ Unexpected Error: $e");
    }
  }
}
