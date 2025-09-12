import 'package:dio/dio.dart';
import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/student_models/quiz_model.dart'; // فيه QuizModel

class QuizService {
  final Api _api = Api();
  final StorageService storageService = StorageService();

  /// 🔹 Get Quiz details (Start attempt)
  Future<QuizModel> getQuiz({
    required int courseId,
    required int sectionId,
    required int quizId,
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found. Please login again.");
    }

    try {
      final response = await _api.get(
        url:
            "${ApiConstants.baseUrl}/student/course/$courseId/section/$sectionId/quiz/$quizId/",
        token: token,
      );

      print("✅ Quiz Response: $response");

      return QuizModel.fromJson(response);
    } on DioException catch (e) {
      print("❌ Failed to fetch quiz: ${e.response?.data}");
      rethrow;
    }
  }

  /// 🔹 Submit quiz attempt
  Future<Map<String, dynamic>> submitQuiz({
    required int courseId,
    required int sectionId,
    required int quizId,
    required int attemptId,
    required List<Map<String, int>> answers, // {question_id: choice_id}
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found. Please login again.");
    }
    

    try {
      final response = await _api.post(
        url:
            "${ApiConstants.baseUrl}/student/course/$courseId/section/$sectionId/quiz/$quizId/",
        body: {"attempt_id": attemptId, "answers": answers},
        token: token,
      );

      print("✅ Quiz Submitted: $response");
      return response;
    } on DioException catch (e) {
      print("❌ Failed to submit quiz: ${e.response?.data}");
      rethrow;
    }
  }

}
