import 'package:study_platform/models/authentication/user_model.dart';
import 'package:study_platform/models/users/base_profile_model.dart';

class ParentProfileModel extends BaseProfileModel {
  final String children;
  final String occupation;
  final String emergencyContact;
  final bool emailNotifications;
  final bool smsNotifications;

  ParentProfileModel({
    required super.id,
    required super.user,
    required super.createdAt,
    required super.updatedAt,
    required this.children,
    required this.occupation,
    required this.emergencyContact,
    required this.emailNotifications,
    required this.smsNotifications,
  });

  factory ParentProfileModel.fromJson(Map<String, dynamic> json) {
    return ParentProfileModel(
      id: json["id"],
      user: UserModel.fromJson(json["user"]),
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      children: json["children"] ?? "",
      occupation: json["occupation"] ?? "",
      emergencyContact: json["emergency_contact"] ?? "",
      emailNotifications: json["email_notifications"] ?? false,
      smsNotifications: json["sms_notifications"] ?? false,
    );
  }
}
