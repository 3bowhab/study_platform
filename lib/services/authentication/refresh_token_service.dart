import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/storage_service.dart';

class RefreshTokenService {
  final Api api = Api();
  final StorageService storageService = StorageService();
  
  Future<String?> refreshAccessToken() async {
    try {
      final refresh = await storageService.getRefreshToken();

      if (refresh == null) {
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
      if (newAccess != null) {
        await storageService.resetTokens(newAccess, refresh);
        print("✅ Access token refreshed");
        return newAccess;
      } else {
        print("❌ Refresh API did not return access");
        return null;
      }
    } catch (e) {
      print("❌ Refresh failed: $e");

      // هنا لو السيرفر قال التوكين بايظ أو Expired نمسحه
      await storageService.resetTokens("", "");
      return null;
    }
  }
}
