import 'package:study_platform/models/student_models/course_model.dart';

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

class CourseResponse {
  final CourseModel course;

  CourseResponse({required this.course});

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(course: CourseModel.fromJson(json['course']));
  }

  Map<String, dynamic> toJson() => {"course": course.toJson()};
}