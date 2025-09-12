import 'package:study_platform/models/student_models/choice_model.dart';
import 'package:study_platform/models/student_models/course_response.dart';

class QuestionModel {
  final int id;
  final String questionText;
  final String questionType;
  final int points;
  final int order;
  final String? explanation;
  final List<ChoiceModel> choices;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.points,
    required this.order,
    this.explanation,
    required this.choices,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: parseInt(json['id']),
      questionText: json['question_text'] ?? '',
      questionType: json['question_type'] ?? '',
      points: parseInt(json['points']),
      order: parseInt(json['order']),
      explanation: json['explanation'],
      choices:
          (json['choices'] as List? ?? [])
              .map((e) => ChoiceModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "question_text": questionText,
    "question_type": questionType,
    "points": points,
    "order": order,
    "explanation": explanation,
    "choices": choices.map((e) => e.toJson()).toList(),
  };
}
