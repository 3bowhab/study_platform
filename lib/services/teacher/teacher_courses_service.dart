import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/student_models/course_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class TeacherCoursesService {
  /// 🟢 Get all courses for the authenticated teacher
  Future<List<CourseModel>> getAllTeacherCourses() async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found. Please login again.");
    }

    try {
      final response = await _api.get(
        url: ApiConstants.teacherCourses, // 👈 الـ endpoint بتاع المدرس
        token: token, // لازم المدرس يكون authenticated
      );

      print("✅ Teacher courses fetched successfully");

      final List<dynamic> data = response;
      return data.map((json) => CourseModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ Failed to fetch teacher courses: $e");
      rethrow;
    }
  }

  /// 🟢 Create a new course for the authenticated teacher
  Future<CourseModel> createCourse({
    required String title,
    required String description,
    required String thumbnail,
    required String status, // draft, published, etc
    required String difficulty, // beginner, intermediate, advanced
    required double price,
    required int durationHours,
  }) async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found. Please login again.");
    }

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

      final response = await _api.post(
        url: ApiConstants.teacherCourses, // 👈 نفس الـ endpoint
        body: body,
        token: token,
      );

      print("✅ Course created successfully");

      return CourseModel.fromJson(response);
    } catch (e) {
      print("❌ Failed to create course: $e");
      rethrow;
    }
  }
}
