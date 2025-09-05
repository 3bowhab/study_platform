import 'package:study_platform/models/authentication/user_model.dart';

class BaseProfileModel {
  final int id;
  final UserModel user;
  final String createdAt;
  final String updatedAt;

  BaseProfileModel({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });
}
