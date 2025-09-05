import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/users/student_profile_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class StudentProfileService {
  Future<StudentProfileModel> getStudentProfile() async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await _api.get(
        url: ApiConstants.studentProfile, // اعمل constant للـ endpoint
        token: token,
      );

      final studentProfile = StudentProfileModel.fromJson(response);

      print("✅ Student profile fetched successfully");
      return studentProfile;
    } catch (e) {
      print("❌ Failed to fetch student profile: $e");
      rethrow;
    }
  }
}
