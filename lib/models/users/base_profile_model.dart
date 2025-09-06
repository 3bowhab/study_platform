
import 'package:study_platform/models/users/user_profile_model.dart';

class BaseProfileModel {
  final int id;
  final UserProfileModel user;
  final String createdAt;
  final String updatedAt;

  BaseProfileModel({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });
}
