import 'package:study_platform/models/student_models/course_model.dart';

class EnrollmentModel {
  final int id;
  final CourseModel course;
  final String enrolledAt;
  final bool isActive;
  final String progressPercentage;
  final String? completionDate;
  final int sectionsCompleted;
  final int quizzesPassed;
  final int totalTimeSpentMinutes;
  final String? lastActivity;

  EnrollmentModel({
    required this.id,
    required this.course,
    required this.enrolledAt,
    required this.isActive,
    required this.progressPercentage,
    this.completionDate,
    required this.sectionsCompleted,
    required this.quizzesPassed,
    required this.totalTimeSpentMinutes,
    this.lastActivity,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'],
      course: CourseModel.fromJson(json['course']),
      enrolledAt: json['enrolled_at'] ?? '',
      isActive: json['is_active'] ?? false,
      progressPercentage: json['progress_percentage']?.toString() ?? '0',
      completionDate: json['completion_date'],
      sectionsCompleted: json['sections_completed'] ?? 0,
      quizzesPassed: json['quizzes_passed'] ?? 0,
      totalTimeSpentMinutes: json['total_time_spent_minutes'] ?? 0,
      lastActivity: json['last_activity'],
    );
  }
}
