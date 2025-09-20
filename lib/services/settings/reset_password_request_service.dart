import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';

class PasswordResetService {
  final Api api = Api();

  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await api.post(
        url: ApiConstants.passwordResetRequest,
        body: {"email": email},
        token: null,
      );
      print("Response from API: $response");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmPasswordReset(
    String otp,
    String newPassword,
    String newPasswordConfirm,
  ) async {
    try {
      final response = await api.post(
        url: "${ApiConstants.passwordResetConfirm}/$otp/",
        body: {
          "token": otp,
          "new_password": newPassword,
          "new_password_confirm": newPasswordConfirm,
        },
        token: null,
      );
      print("Response from API: $response");
    } catch (e) {
      throw Exception("❌ Unexpected Error: $e");
    }
  }
}
