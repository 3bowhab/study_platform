import 'package:dio/dio.dart';
import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/student_models/course_model.dart';

class MyCoursesService {
  final Api _api = Api();
  final StorageService storageService = StorageService();

  Future<List<CourseModel>> getMyCourses() async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found. Please login again.");
    }


    try {
      final response = await _api.get(url: ApiConstants.studentMyCourses, token: token);

      print("✅ My Courses Response: $response");

      if (response is List) {
        return response.map((c) => CourseModel.fromJson(c)).toList();
      } else {
        throw Exception("❌ Unexpected response format: $response");
      }
    } on DioException catch (e) {
      print("❌ Failed to fetch my courses: ${e.response?.data}");
      rethrow;
    }
  }
}
