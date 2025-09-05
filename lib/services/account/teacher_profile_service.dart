import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/users/teacher_profile_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class TeacherProfileService {
  Future<TeacherProfileModel> getTeacherProfile() async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await _api.get(
        url: ApiConstants.teacherProfile, // اعمل constant للـ endpoint
        token: token,
      );

      final teacherProfile = TeacherProfileModel.fromJson(response);

      print("✅ Teacher profile fetched successfully");
      return teacherProfile;
    } catch (e) {
      print("❌ Failed to fetch teacher profile: $e");
      rethrow;
    }
  }
}
