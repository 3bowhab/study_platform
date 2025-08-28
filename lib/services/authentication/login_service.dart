import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/models/authentication/auth_response_model.dart';
import 'package:study_platform/models/authentication/login_model.dart';

class LoginService {
  final Api api = Api();

  Future<AuthResponseModel> login(LoginModel model) async {
    try {
      final response = await api.post(
        url: ApiConstants.login,
        body: model.toJson(),
        token: null,
      );
      print('Response from API: $response');
      return AuthResponseModel.fromJson(response);
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}
