import 'package:study_platform/models/authentication/user_model.dart';
import 'package:study_platform/models/users/base_profile_model.dart';

class StudentProfileModel extends BaseProfileModel {
  final String parentInfo;
  final String gradeLevel;
  final String schoolName;
  final String learningGoals;
  final String interests;

  StudentProfileModel({
    required super.id,
    required super.user,
    required super.createdAt,
    required super.updatedAt,
    required this.parentInfo,
    required this.gradeLevel,
    required this.schoolName,
    required this.learningGoals,
    required this.interests,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      id: json["id"],
      user: UserModel.fromJson(json["user"]),
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      parentInfo: json["parent_info"] ?? "",
      gradeLevel: json["grade_level"] ?? "",
      schoolName: json["school_name"] ?? "",
      learningGoals: json["learning_goals"] ?? "",
      interests: json["interests"] ?? "",
    );
  }
}
