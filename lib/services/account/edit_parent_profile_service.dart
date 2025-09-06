import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/users/parent_profile_model.dart';

class EditParentProfileService {
  final Api _api = Api();
  final StorageService storageService = StorageService();

  Future<ParentProfileModel?> updateParentProfile(ParentProfileModel parent) async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await _api.patch(
        url: ApiConstants.parentProfile,
        body: parent.toJson(),
        token: token,
      );

      print("✅ [UPDATE PARENT PROFILE SUCCESS]");
      return ParentProfileModel.fromJson(response);
    } catch (e) {
      print("❌ [UPDATE PARENT PROFILE ERROR] $e");
      rethrow;
    }  
  }
}