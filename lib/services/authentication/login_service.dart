import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/authentication/auth_response_model.dart';
import 'package:study_platform/models/authentication/login_model.dart';

class LoginService {
  final Api api = Api();
  final StorageService storageService = StorageService();

  Future<AuthResponseModel> login(LoginModel model) async {
    try {
      final response = await api.post(
        url: ApiConstants.login,
        body: model.toJson(),
        token: null,
      );

      print('Response from API: $response');

      final authResponse = AuthResponseModel.fromJson(response);

      // ✅ خزّن التوكينات بعد نجاح اللوجين
      await storageService.saveTokens(
        authResponse.tokens.access,
        authResponse.tokens.refresh,
        authResponse.user.fullName,
        authResponse.user.email,
        authResponse.user.userType,
      );

      return authResponse;
    } catch (e) {
      print('❌ Error occurred in login: $e');
      rethrow;
    }
  }
}
