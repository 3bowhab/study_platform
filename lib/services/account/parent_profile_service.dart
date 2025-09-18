import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/users/parent_profile_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class ParentProfileService {
  Future<ParentProfileModel> getParentProfile() async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await _api.get(
        url: ApiConstants.parentProfile, // اعمل constant للـ endpoint
        token: token,
      );

      final parentProfile = ParentProfileModel.fromJson(response["profile"]);


      print("✅ Parent profile fetched successfully");
      return parentProfile;
    } catch (e) {
      print("❌ Failed to fetch parent profile: $e");
      rethrow;
    }
  }
}
