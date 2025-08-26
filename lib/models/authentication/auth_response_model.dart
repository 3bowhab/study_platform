import 'package:study_platform/models/authentication/tokens_model.dart';
import 'package:study_platform/models/authentication/user_model.dart';

class AuthResponseModel {
  final String message;
  final UserModel user;
  final TokensModel tokens;

  AuthResponseModel({
    required this.message,
    required this.user,
    required this.tokens,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] ?? '',
      user: UserModel.fromJson(json['user']),
      tokens: TokensModel.fromJson(json['tokens']),
    );
  }
}
