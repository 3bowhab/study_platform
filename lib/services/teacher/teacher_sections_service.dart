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
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      final response = await _api.get(
        url: "${ApiConstants.teacherCourses}$courseId/sections/",
        token: token,
      );

      final List<dynamic> data = response;
      return data.map((json) => SectionModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 🟢 Get single section by id
  Future<SectionModel> getSectionById(int id) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      final response = await _api.get(
        url: "${ApiConstants.teacherSections}$id/",
        token: token,
      );

      return SectionModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// 🟢 Create new section
  Future<SectionModel> createSection({
    required int courseId,
    required String title,
    String? description,
    String contentType = "text",
    String content = "",
    int order = 0,
    int durationMinutes = 0,
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    final body = {
      "title": title,
      "description": description ?? "",
      "content_type": contentType,
      "content": content,
      "order": order,
      "duration_minutes": durationMinutes,
    };

    try {
      final response = await _api.post(
        url: "${ApiConstants.teacherCourses}$courseId/sections/",
        body: body,
        token: token,
      );

      return SectionModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// 🟡 Update section
  Future<SectionModel> updateSection({
    required int id,
    required String title,
    String? description,
    String contentType = "text",
    String content = "",
    int order = 0,
    int durationMinutes = 0,
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    final body = {
      "title": title,
      "description": description ?? "",
      "content_type": contentType,
      "content": content,
      "order": order,
      "duration_minutes": durationMinutes,
    };

    try {
      final response = await _api.put(
        url: "${ApiConstants.teacherSections}$id/",
        body: body,
        token: token,
      );

      return SectionModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// 🔴 Delete section
  Future<void> deleteSection(int id) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      await _api.delete(
        url: "${ApiConstants.teacherSections}$id/",
        token: token,
      );
    } catch (e) {
      rethrow;
    }
  }
}
