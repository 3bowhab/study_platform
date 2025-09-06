import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/users/student_profile_model.dart';

class EditStudentProfileService {
  final Api _api = Api();
  final StorageService storageService = StorageService();

  Future<StudentProfileModel?> updateStudentProfile(StudentProfileModel student,) async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await _api.patch(
        url: ApiConstants.studentProfile,
        body: student.toJson(), // ✅ بستخدم الموديل
        token: token,
      );

      print("✅ [UPDATE STUDENT PROFILE SUCCESS]");
      return StudentProfileModel.fromJson(response);
    } catch (e) {
      print("❌ [UPDATE STUDENT PROFILE ERROR] $e");
      rethrow;
    }
  }
}
