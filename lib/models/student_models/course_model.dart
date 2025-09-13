import 'package:study_platform/models/student_models/course_response.dart';
import 'package:study_platform/models/student_models/section_model.dart';

class CourseModel {
  final int id;
  final String title;
  final String description;
  final String teacherName;
  final String? thumbnail;
  final String status;
  final String difficulty;
  final double price;
  final int durationHours;
  final int totalSections;
  final int totalQuizzes;
  final int totalEnrollments;
  final int totalViews;
  final double averageRating;
  final String createdAt;
  final String updatedAt;
  final List<SectionModel> sections;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.teacherName,
    this.thumbnail,
    required this.status,
    required this.difficulty,
    required this.price,
    required this.durationHours,
    required this.totalSections,
    required this.totalQuizzes,
    required this.totalEnrollments,
    required this.totalViews,
    required this.averageRating,
    required this.createdAt,
    required this.updatedAt,
    required this.sections,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: parseInt(json['id']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      thumbnail: json['thumbnail'],
      status: json['status'] ?? '',
      difficulty: json['difficulty'] ?? '',
      price: parseDouble(json['price']),
      durationHours: parseInt(json['duration_hours']),
      totalSections: parseInt(json['total_sections']),
      totalQuizzes: parseInt(json['total_quizzes']),
      totalEnrollments: parseInt(json['total_enrollments']),
      totalViews: parseInt(json['total_views']),
      averageRating: parseDouble(json['average_rating']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      sections:
          (json['sections'] as List? ?? [])
              .map((e) => SectionModel.fromJson(e))
              .toList(),
    );
  }

   Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "teacher_name": teacherName,
    "thumbnail": thumbnail,
    "status": status,
    "difficulty": difficulty,
    "price": price,
    "duration_hours": durationHours,
    "total_sections": totalSections,
    "total_quizzes": totalQuizzes,
    "total_enrollments": totalEnrollments,
    "total_views": totalViews,
    "average_rating": averageRating,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "sections": sections.map((e) => e.toJson()).toList(),
  };
}
