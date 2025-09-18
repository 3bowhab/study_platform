import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/student_models/quiz_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class TeacherQuizService {
  /// 🟢 Get quiz by SectionId
  Future<QuizModel?> getQuizBySection(int sectionId) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      final response = await _api.get(
        url: "${ApiConstants.teacherSections}$sectionId/",
        // 👈 لازم الـ API يكون عامل endpoint بالشكل ده
        token: token,
      );

      if (response == null || response.isEmpty) return null;

      print("✅ Quiz for section $sectionId fetched successfully");
      return QuizModel.fromJson(response);
    } catch (e) {
      print("❌ Failed to fetch quiz by section: $e");
      return null; // ممكن يكون مفيش كويز اساساً
    }
  }

  /// 🟢 Update quiz (PUT)
  Future<QuizModel> updateQuiz({
    required int sectionId,
    required String title,
    required String description,
    required int timeLimitMinutes,
    required int passingScore,
    required int maxAttempts,
    required bool shuffleQuestions,
    required List<Map<String, dynamic>> questions,
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      final body = {
        "title": title,
        "description": description,
        "time_limit_minutes": timeLimitMinutes,
        "passing_score": passingScore,
        "max_attempts": maxAttempts,
        "shuffle_questions": shuffleQuestions,
        "questions": questions,
      };

      final response = await _api.put(
        url: "${ApiConstants.teacherQuizzes}$sectionId/",
        body: body,
        token: token,
      );

      print("✅ Quiz updated successfully");
      return QuizModel.fromJson(response);
    } catch (e) {
      print("❌ Failed to update quiz: $e");
      rethrow;
    }
  }

  /// 🟢 Partial Update quiz (PATCH)
  Future<QuizModel> patchQuiz({
    required int id,
    Map<String, dynamic>? data,
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      final response = await _api.patch(
        url: "${ApiConstants.teacherQuizzes}$id/",
        body: data ?? {},
        token: token,
      );

      print("✅ Quiz patched successfully");
      return QuizModel.fromJson(response);
    } catch (e) {
      print("❌ Failed to patch quiz: $e");
      rethrow;
    }
  }

  /// 🟢 Delete quiz
  Future<void> deleteQuiz(int id) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      await _api.delete(
        url: "${ApiConstants.teacherQuizzes}$id/",
        token: token,
      );
      print("✅ Quiz deleted successfully");
    } catch (e) {
      print("❌ Failed to delete quiz: $e");
      rethrow;
    }
  }
}
