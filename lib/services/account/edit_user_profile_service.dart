import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/users/user_profile_model.dart';

class EditUserProfileService {
  final Api _api = Api();
  final StorageService storageService = StorageService();

  Future<UserProfileModel?> updateUserProfile(UserProfileModel user) async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await _api.patch(
        url: ApiConstants.userProfile,
        body: user.toJson(),
        token: token,
      );

      print("✅ [UPDATE USER PROFILE SUCCESS]");
      return UserProfileModel.fromJson(response);
    } catch (e) {
      print("❌ [UPDATE USER PROFILE ERROR] $e");
      rethrow;
    }
  }
}
