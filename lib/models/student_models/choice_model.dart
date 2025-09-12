import 'package:study_platform/models/student_models/course_response.dart';

class ChoiceModel {
  final int id;
  final String choiceText;
  final bool isCorrect;
  final int order;

  ChoiceModel({
    required this.id,
    required this.choiceText,
    required this.isCorrect,
    required this.order,
  });

  factory ChoiceModel.fromJson(Map<String, dynamic> json) {
    return ChoiceModel(
      id: parseInt(json['id']),
      choiceText: json['choice_text'] ?? '',
      isCorrect: json['is_correct'] ?? false,
      order: parseInt(json['order']),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "choice_text": choiceText,
    "is_correct": isCorrect,
    "order": order,
  };
}
