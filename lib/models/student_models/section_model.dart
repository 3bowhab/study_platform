import 'package:study_platform/models/student_models/course_response.dart';
import 'package:study_platform/models/student_models/quiz_model.dart';

class SectionModel {
  final int id;
  final String title;
  final String description;
  final String contentType;
  final String content;
  final String? videoFile;
  final String? pdfFile;
  final int order;
  final int durationMinutes;
  final int totalViews;
  final QuizModel? quiz;
  final bool hasQuiz;
  final String createdAt;
  final String updatedAt;

  SectionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.contentType,
    required this.content,
    this.videoFile,
    this.pdfFile,
    required this.order,
    required this.durationMinutes,
    required this.totalViews,
    this.quiz,
    required this.hasQuiz,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: parseInt(json['id']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      contentType: json['content_type'] ?? '',
      content: json['content'] ?? '',
      videoFile: json['video_file'],
      pdfFile: json['pdf_file'],
      order: parseInt(json['order']),
      durationMinutes: parseInt(json['duration_minutes']),
      totalViews: parseInt(json['total_views']),
      quiz: json['quiz'] != null ? QuizModel.fromJson(json['quiz']) : null,
      hasQuiz: json['has_quiz'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "content_type": contentType,
    "content": content,
    "video_file": videoFile,
    "pdf_file": pdfFile,
    "order": order,
    "duration_minutes": durationMinutes,
    "total_views": totalViews,
    "quiz": quiz?.toJson(),
    "has_quiz": hasQuiz,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
