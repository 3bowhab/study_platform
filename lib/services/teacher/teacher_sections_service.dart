import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/student_models/section_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class TeacherSectionsService {
  /// 🟢 Get all sections for a specific course
  Future<List<SectionModel>> getCourseSections(int courseId) async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found. Please login again.");
    }

    try {
      final response = await _api.get(
        url: "${ApiConstants.teacherCourses}$courseId/sections/",
        token: token,
      );

      print("✅ Sections fetched successfully for course $courseId");

      final List<dynamic> data = response;
      return data.map((json) => SectionModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ Failed to fetch sections: $e");
      rethrow;
    }
  }

  /// 🟢 Create a new section in a specific course
  Future<SectionModel> createSection({
    required int courseId,
    required String title,
    String? description,
    String contentType = "text", // ممكن يبقى text, video, pdf
    String content = "",
    int order = 0,
    int durationMinutes = 0,
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found. Please login again.");
    }

    try {
      final body = {
        "title": title,
        "description": description ?? "",
        "content_type": contentType,
        "content": content,
        "order": order,
        "duration_minutes": durationMinutes,
      };

      final response = await _api.post(
        url: "${ApiConstants.teacherCourses}$courseId/sections/",
        body: body,
        token: token,
      );

      print("✅ Section created successfully in course $courseId");

      return SectionModel.fromJson(response);
    } catch (e) {
      print("❌ Failed to create section: $e");
      rethrow;
    }
  }
}
