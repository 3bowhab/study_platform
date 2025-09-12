import 'package:study_platform/models/student_models/course_response.dart';
import 'package:study_platform/models/student_models/question_model.dart';

class QuizModel {
  final int id;
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
      id: parseInt(json['id']),
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
}
