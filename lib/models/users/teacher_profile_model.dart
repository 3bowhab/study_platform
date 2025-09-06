import 'package:study_platform/models/authentication/user_model.dart';
import 'package:study_platform/models/users/base_profile_model.dart';

class TeacherProfileModel extends BaseProfileModel {
  final String specialization;
  final int experienceYears;
  final String education;
  final String certifications;
  final double hourlyRate;
  final bool isApproved;
  final String approvedAt;
  final String linkedinUrl;
  final String websiteUrl;
  final int approvedBy;

  TeacherProfileModel({
    required super.id,
    required super.user,
    required super.createdAt,
    required super.updatedAt,
    required this.specialization,
    required this.experienceYears,
    required this.education,
    required this.certifications,
    required this.hourlyRate,
    required this.isApproved,
    required this.approvedAt,
    required this.linkedinUrl,
    required this.websiteUrl,
    required this.approvedBy,
  });

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileModel(
      id: json["id"],
      user: UserModel.fromJson(json["user"]),
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      specialization: json["specialization"] ?? "",
      experienceYears: json["experience_years"] ?? 0,
      education: json["education"] ?? "",
      certifications: json["certifications"] ?? "",
      hourlyRate: double.tryParse(json["hourly_rate"].toString()) ?? 0.0,
      isApproved: json["is_approved"] ?? false,
      approvedAt: json["approved_at"] ?? "",
      linkedinUrl: json["linkedin_url"] ?? "",
      websiteUrl: json["website_url"] ?? "",
      approvedBy: json["approved_by"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "specialization": specialization,
      "experience_years": experienceYears,
      "education": education,
      "certifications": certifications,
      "hourly_rate": hourlyRate,
      "is_approved": isApproved,
      "approved_at": approvedAt,
      "linkedin_url": linkedinUrl,
      "website_url": websiteUrl,
      "approved_by": approvedBy,
    };
  }
}
