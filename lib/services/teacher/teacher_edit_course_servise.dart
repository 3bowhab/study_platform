import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/student_models/course_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class TeacherEditCourseService {
  /// 🟢 Get all courses for the authenticated teacher
  Future<List<CourseModel>> getAllTeacherCourses() async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      final response = await _api.get(
        url: ApiConstants.teacherCourses,
        token: token,
      );

      final List<dynamic> data = response;
      return data.map((json) => CourseModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ Failed to fetch teacher courses: $e");
      rethrow;
    }
  }

  /// 🟢 Get single course with details (sections + quizzes)
  Future<CourseModel> getCourseById(int id) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      final response = await _api.get(
        url: "${ApiConstants.teacherCourses}$id/",
        token: token,
      );

      return CourseModel.fromJson(response);
    } catch (e) {
      print("❌ Failed to fetch course $id: $e");
      rethrow;
    }
  }

  /// 🟢 Update course (PUT - full update)
  Future<CourseModel> updateCourse({
    required int id,
    required String title,
    required String description,
    required String thumbnail,
    required String status,
    required String difficulty,
    required double price,
    required int durationHours,
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      final body = {
        "title": title,
        "description": description,
        "thumbnail": null,
        "status": status,
        "difficulty": difficulty,
        "price": price,
        "duration_hours": durationHours,
      };

      final response = await _api.put(
        url: "${ApiConstants.teacherCourses}$id/",
        body: body,
        token: token,
      );

      return CourseModel.fromJson(response);
    } catch (e) {
      print("❌ Failed to update course $id: $e");
      rethrow;
    }
  }

  /// 🟢 Update course (PATCH - partial update)
  Future<CourseModel> patchCourse({
    required int id,
    Map<String, dynamic>? updates,
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      final response = await _api.patch(
        url: "${ApiConstants.teacherCourses}$id/",
        body: updates ?? {},
        token: token,
      );

      return CourseModel.fromJson(response);
    } catch (e) {
      print("❌ Failed to patch course $id: $e");
      rethrow;
    }
  }

  /// 🟢 Delete course
  Future<void> deleteCourse(int id) async {
    final token = await storageService.getAccessToken();
    if (token == null) throw Exception("❌ No token found. Please login again.");

    try {
      await _api.delete(
        url: "${ApiConstants.teacherCourses}$id/",
        token: token,
      );
      print("✅ Course $id deleted successfully");
    } catch (e) {
      print("❌ Failed to delete course $id: $e");
      rethrow;
    }
  }
}
