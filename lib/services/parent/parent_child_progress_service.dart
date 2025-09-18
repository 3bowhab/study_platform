import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/users/parent_profile_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class ParentChildProgressService {
  /// ✅ يجيب الـ Parent Profile الأول
  Future<ParentProfileModel> getParentProfile() async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found, please login again.");
    }

    final response = await _api.get(
      url: ApiConstants.parentProfile,
      token: token,
    );

    final parentProfile = ParentProfileModel.fromJson(response["profile"]);
    print("✅ Parent profile fetched successfully");
    return parentProfile;
  }

  /// ✅ يجيب تقرير إتمام الأقسام لطفل معين
  Future<Map<String, dynamic>> getChildSectionsCompletion(int childId) async {
    final token = await storageService.getAccessToken();
    if (token == null) {
      throw Exception("❌ No token found, please login again.");
    }

    final response = await _api.get(
      url:
          "${ApiConstants.baseUrl}/parent/children/$childId/sections-completion/",
      token: token,
    );

    print("✅ Sections completion fetched successfully for child $childId");
    return response; // هيكون بالشكل { child: {...}, courses: [], overall_summary: {...} }
  }

  /// ✅ أوتوماتيك: يجيب أول ابن من البروفايل ويرجع تقريره
  Future<Map<String, dynamic>> getFirstChildProgress() async {
    final parentProfile = await getParentProfile();

    if (parentProfile.children.isEmpty) {
      throw Exception("❌ No children found for this parent.");
    }

    final firstChildId = parentProfile.children.first.id;
    return await getChildSectionsCompletion(firstChildId);
  }
}
