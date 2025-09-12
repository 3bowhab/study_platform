import 'package:study_platform/models/student_models/course_response.dart';
import 'package:study_platform/models/student_models/question_model.dart';

class QuizModel {
  final int id;
  final int? attemptId; // جديد
  final String title;
  final String description;
  final int timeLimitMinutes;
  final int passingScore;
  final int maxAttempts;
  final bool shuffleQuestions;
  final int totalAttempts;
  final double averageScore;
  final List<QuestionModel> questions;
  final int questionCount;

  QuizModel({
    required this.id,
    this.attemptId,
    required this.title,
    required this.description,
    required this.timeLimitMinutes,
    required this.passingScore,
    required this.maxAttempts,
    required this.shuffleQuestions,
    required this.totalAttempts,
    required this.averageScore,
    required this.questions,
    required this.questionCount,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: parseInt(json['quiz_id'] ?? json['id']),
      attemptId:
          json['attempt_id'] != null ? parseInt(json['attempt_id']) : null,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timeLimitMinutes: parseInt(json['time_limit_minutes']),
      passingScore: parseInt(json['passing_score']),
      maxAttempts: parseInt(json['max_attempts']),
      shuffleQuestions: json['shuffle_questions'] ?? false,
      totalAttempts: parseInt(json['total_attempts']),
      averageScore: parseDouble(json['average_score']),
      questions:
          (json['questions'] as List? ?? [])
              .map((e) => QuestionModel.fromJson(e))
              .toList(),
      questionCount: parseInt(json['question_count']),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "attempt_id": attemptId,
    "title": title,
    "description": description,
    "time_limit_minutes": timeLimitMinutes,
    "passing_score": passingScore,
    "max_attempts": maxAttempts,
    "shuffle_questions": shuffleQuestions,
    "total_attempts": totalAttempts,
    "average_score": averageScore,
    "questions": questions.map((e) => e.toJson()).toList(),
    "question_count": questionCount,
  };

  QuizModel copyWith({
    int? id,
    int? attemptId,
    String? title,
    String? description,
    int? timeLimitMinutes,
    int? passingScore,
    int? maxAttempts,
    bool? shuffleQuestions,
    int? totalAttempts,
    double? averageScore,
    List<QuestionModel>? questions,
    int? questionCount,
  }) {
    return QuizModel(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      passingScore: passingScore ?? this.passingScore,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      averageScore: averageScore ?? this.averageScore,
      questions: questions ?? this.questions,
      questionCount: questionCount ?? this.questionCount,
    );
  }
}
