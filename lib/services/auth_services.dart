import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/models/login_model.dart';
import 'package:study_platform/models/register_model.dart';

final Api _api = Api();

class RegisterService {
  Future<dynamic> register(RegisterModel model) async {
    try {
      final response = await _api.post(
        url: ApiConstants.register,
        body: model.toJson(),
        token: null, // تسجيل مستخدم جديد مش محتاج توكن
      );

      print('Response from API: $response');
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> confirmEmail(String otp) async {
    try {
      final response = await _api.post(
        url: "${ApiConstants.verifyEmail}/$otp/",
        body: {},
        token: null, // تأكيد البريد الإلكتروني مش محتاج توكن
      );

      print('Response from API: $response');
    } catch (e) {
      rethrow;
    }
  }
}

class LoginService {
  Future<dynamic> login(LoginModel model) async {
    try {
      final response = await _api.post(
        url: ApiConstants.login,
        body: model.toJson(),
        token: null, // تسجيل مستخدم جديد مش محتاج توكن
      );

      print('Response from API: $response');
    } catch (e) {
      rethrow;
    }
  }
}