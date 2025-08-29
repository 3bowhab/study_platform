import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';

class PasswordResetService {
  final Api api = Api();
  final StorageService storageService = StorageService();

  Future<void> requestPasswordReset() async {
    try {
      final email = await storageService.getEmail(); // ✅ نجيب الإيميل من التخزين
      if (email == null) throw Exception("No email found in storage!");

      final response = await api.post(
        url: ApiConstants.passwordResetRequest,
        body: {"email": email},
        token: null, // مش محتاج توكن
      );

      print("Response from API: $response");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmPasswordReset(String otp, String newPassword, String newPasswordConfirm) async {
    try {
      final response = await api.post(
        url: "${ApiConstants.passwordResetConfirm}/$otp/",
        body: {"token": otp, "new_password": newPassword, "new_password_confirm": newPasswordConfirm},
        token: null, // مش محتاج توكن
      );

      print("Response from API: $response");
    } catch (e) {
      throw Exception("❌ Unexpected Error: $e");
    }
  }
}
