import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/models/student_models/couse_model.dart';

final Api _api = Api();

class StudentCoursesService {
  Future<List<CourseModel>> getAllCourses() async {
    try {
      final response = await _api.get(
        url: ApiConstants.studentGetAllCourses, // 👈 اعمل constant للـ endpoint
        // مش محتاج token لأن ده بيرجع public courses
        token: null
      );

      print("✅ All courses fetched successfully");

      final List<dynamic> data = response;
      return data.map((json) => CourseModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ Failed to fetch courses: $e");
      rethrow;
    }
  }
}
