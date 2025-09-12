import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/student_models/course_response.dart';
// import 'package:study_platform/models/student_models/course_model.dart';

class CourseDetailsService {
  final Api _api = Api();
  final StorageService _storageService = StorageService();

  Future<CourseResponse> getCourseDetails(int courseId) async {
    try {
      final token = await _storageService.getAccessToken();
      if (token == null) throw Exception("❌ No token found");

      final response = await _api.get(
        url: "${ApiConstants.studentCourseInfo}$courseId/",
        token: token,
      );

      print("✅ Course details fetched successfully");
      return CourseResponse.fromJson(response);
    } catch (e) {
      print("❌ Failed to fetch course details: $e");
      rethrow;
    }
  }
}
