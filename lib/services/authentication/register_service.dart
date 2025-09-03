import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/models/authentication/auth_response_model.dart';
import 'package:study_platform/models/authentication/register_model.dart';
import 'package:study_platform/services/account/delete_account_service.dart';

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

      final authResponse = AuthResponseModel.fromJson(response);

      // ✅ خزّن التوكينات بعد نجاح التسجيل
      await storageService.saveTokens(
        authResponse.tokens.access,
        authResponse.tokens.refresh,
        authResponse.user.fullName,
        authResponse.user.email,
      );

      return authResponse;
    } catch (e) {
      print('❌ Error occurred in register: $e');
      rethrow;
    }
  }

  Future<String> confirmEmail(String otp) async {
    try {
      final response = await api.post(
        url: "${ApiConstants.verifyEmail}/$otp/",
        body: {},
        token: null, // تأكيد البريد الإلكتروني مش محتاج توكن
      );

      print('Response from API: $response');
      return response["message"]; // ✅ هنا هي Map أصلاً
    } catch (e) {
      rethrow;
    }
  }
}
