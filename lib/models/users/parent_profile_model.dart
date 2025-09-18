import 'package:study_platform/models/users/base_profile_model.dart';
import 'package:study_platform/models/users/user_profile_model.dart';
import 'package:study_platform/models/users/student_profile_model.dart';

class ParentProfileModel extends BaseProfileModel {
  final List<StudentProfileModel> children;
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
      id: json["id"] ?? 0,
      user: UserProfileModel.fromJson(json["user"]),
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      children:
          (json["children"] as List<dynamic>?)
              ?.map(
                (child) => StudentProfileModel.fromJson({
                  "id": child["id"] ?? 0,
                  "user": {
                    "id": child["id"] ?? 0,
                    "username": child["username"] ?? "",
                    "first_name": child["name"] ?? "",
                    "last_name": "",
                    "full_name": child["name"] ?? "",
                    "email": child["email"] ?? "",
                    "user_type": "student",
                    "phone_number": "",
                    "date_of_birth": "",
                  },
                  "created_at": "",
                  "updated_at": "",
                  "grade_level": child["grade_level"] ?? "",
                }),
              )
              .toList() ??
          [],
      occupation: json["occupation"] ?? "",
      emergencyContact: json["emergency_contact"] ?? "",
      emailNotifications: json["email_notifications"] ?? false,
      smsNotifications: json["sms_notifications"] ?? false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "children": children.map((c) => c.toJson()).toList(),
      "occupation": occupation,
      "emergency_contact": emergencyContact,
      "email_notifications": emailNotifications,
      "sms_notifications": smsNotifications,
      
    };
  }
}
