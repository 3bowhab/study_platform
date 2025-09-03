import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/storage_service.dart';

class RefreshTokenService {
  final Api api = Api();
  final StorageService storageService = StorageService();

  Future<String?> refreshAccessToken() async {
    try {
      final refresh = await storageService.getRefreshToken();
      print("🟢 Current refresh token: $refresh");

      if (refresh == null || refresh.isEmpty) {
        print("❌ No refresh token saved");
        return null;
      }

      final response = await api.post(
        url:
            "https://educational-platform-qg3zn6tpl-youssefs-projects-e2c35ebf.vercel.app/user/token/refresh/",
        body: {"refresh": refresh},
        token: null,
      );

      final newAccess = response["access"];
      final newRefresh = response["refresh"] ?? refresh;

      if (newAccess != null) {
        await storageService.resetTokens(newAccess, newRefresh);
        print("✅ Access token refreshed successfully");
        return newAccess;
      } else {
        print("❌ Refresh API did not return access");
        return null;
      }
    } catch (e) {
      print("❌ Refresh failed: $e");
      await storageService.logout();
      return null;
    }
  }
}
