import 'package:dio/dio.dart';
import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class PostEnrollmentService {

  /// Enroll in a single course temporarily
  Future<void> enrollTemporarySingle(int courseId) async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found. Please login again.");
    }

    final endpoint = "${ApiConstants.studentEnrollTemporaryBase}$courseId/";

    try {
      // مفيش body مطلوب — لو الـ Api.post عندك بياخد "data" أو "body" عدّل الاسم
      await _api.post(
        url: endpoint,
        token: token,
        body: const {}, // أو body: {} حسب توقيع الـ Api بتاعك
      );
      print("✅ Temporarily enrolled in course #$courseId");
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data['error'] == "Already enrolled in this course") {
          throw Exception("already_enrolled");
        }
      }
      rethrow;
    } catch (e) {
      print("❌ Enroll failed: $e");
      rethrow;
    }
  }

  /// Enroll in multiple courses (bulk)
  Future<Map<String, dynamic>> enrollTemporaryBulk(List<int> courseIds) async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found. Please login again.");
    }

    final endpoint = "${ApiConstants.studentEnrollTemporaryBase}bulk/";

    try {
      final response = await _api.post(
        url: endpoint,
        token: token,
        body: {"course_ids": courseIds},
      );

      // ✅ اتأكد إنه Map<String, dynamic>
      if (response is Map<String, dynamic>) {
        print("✅ Bulk Response: $response");
        return response;
      } else {
        throw Exception("❌ Unexpected response format: $response");
      }
    } on DioException catch (e) {
      print("❌ Bulk enroll failed: ${e.response?.data}");
      rethrow;
    }
  }

}
