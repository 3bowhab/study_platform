import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/authentication/auth_response_model.dart';
import 'package:study_platform/models/authentication/login_model.dart';
import 'package:study_platform/models/authentication/register_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class RegisterService {
  Future<AuthResponseModel> register(RegisterModel model) async {
    try {
      final response = await _api.post(
        url: ApiConstants.register,
        body: model.toJson(),
        token: null, // تسجيل مستخدم جديد مش محتاج توكن
      );

      print('Response from API: $response');
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponseModel> confirmEmail(String otp) async {
    try {
      final response = await _api.post(
        url: "${ApiConstants.verifyEmail}/$otp/",
        body: {},
        token: null, // تأكيد البريد الإلكتروني مش محتاج توكن
      );

      print('Response from API: $response');
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}

class LoginService {
  Future<AuthResponseModel> login(LoginModel model) async {
    try {
      final response = await _api.post(
        url: ApiConstants.login,
        body: model.toJson(),
        token: null, // تسجيل مستخدم جديد مش محتاج توكن
      );

      print('Response from API: $response');
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}


class PasswordResetService {
  final StorageService _storage = StorageService();
  Future<void> requestPasswordReset() async {
    try {
      final email = await _storage.getEmail(); // ✅ نجيب الإيميل من التخزين
      if (email == null) throw Exception("No email found in storage!");

      final response = await _api.post(
        url: "https://educational-platform-git-main-youssefs-projects-e2c35ebf.vercel.app/user/password-reset/request/",
        body: {"email": email},
        token: null, // مش محتاج توكن
      );

      print("Response from API: $response");
    } catch (e) {
      rethrow;
    }
  }
}

class PasswordResetConfirmService {
  Future<void> confirmPasswordReset(String otp, String newPassword, String newPasswordConfirm) async {
    try {
      final response = await _api.post(
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

class ChangePasswordService {
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

      final response = await _api.post(
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


class RefreshTokenService {
  Future<String?> refreshAccessToken() async {
    try {
      final refresh = await storageService.getRefreshToken();

      if (refresh == null) {
        print("❌ No refresh token saved");
        return null;
      }

      final response = await _api.post(
        url:
            "https://educational-platform-qg3zn6tpl-youssefs-projects-e2c35ebf.vercel.app/user/token/refresh/",
        body: {"refresh": refresh},
        token: null,
      );

      final newAccess = response["access"];
      if (newAccess != null) {
        await storageService.resetTokens(newAccess, refresh);
        print("✅ Access token refreshed");
        return newAccess;
      } else {
        print("❌ Refresh API did not return access");
        return null;
      }
    } catch (e) {
      print("❌ Refresh failed: $e");

      // هنا لو السيرفر قال التوكين بايظ أو Expired نمسحه
      await storageService.resetTokens("", "");
      return null;
    }
  }
}

