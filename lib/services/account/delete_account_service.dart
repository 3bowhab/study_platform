import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class DeleteAccountService {
  Future<void> deleteAccount() async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await _api.post(
        url: ApiConstants.deleteAccount,
        body: {},
        token: token,
      );

      print("✅ Account deleted successfully: $response");
    } catch (e) {
      // 👇 لو السيرفر قال "User not found" اعتبره successful
      if (e.toString().contains("user_not_found")) {
        print("⚠️ User already deleted, ignore error.");
        return;
      }
      print("❌ Failed to delete account: $e");
      rethrow;
    }
  }
}

