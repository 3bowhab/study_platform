import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/models/authentication/auth_response_model.dart';
import 'package:study_platform/models/authentication/register_model.dart';

class RegisterService {
  final Api api = Api();
  
  Future<AuthResponseModel> register(RegisterModel model) async {
    try {
      final response = await api.post(
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
      final response = await api.post(
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
