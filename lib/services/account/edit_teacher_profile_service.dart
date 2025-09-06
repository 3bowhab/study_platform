import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/users/teacher_profile_model.dart';

class EditTeacherProfileService {
  final Api _api = Api();
  final StorageService storageService = StorageService();

  Future<TeacherProfileModel?> updateTeacherProfile(
    TeacherProfileModel teacher,
  ) async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await _api.patch(
        url: ApiConstants.teacherProfile,
        body: teacher.toJson(),
        token: token,
      );

      print("✅ [UPDATE TEACHER PROFILE SUCCESS]");
      return TeacherProfileModel.fromJson(response);
    } catch (e) {
      print("❌ [UPDATE TEACHER PROFILE ERROR] $e");
      rethrow;
    }
  }
}
