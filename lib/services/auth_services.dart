import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/authentication/auth_response_model.dart';
import 'package:study_platform/models/authentication/login_model.dart';
import 'package:study_platform/models/authentication/register_model.dart';

final Api _api = Api();

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
        url: ApiConstants.passwordReset,
        body: {"email": email},
        token: null, // مش محتاج توكن
      );

      print("Response from API: $response");
    } catch (e) {
      rethrow;
    }
  }
}
