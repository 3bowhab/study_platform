import 'dart:async';
import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/helper/api_constants.dart';

class RefreshTokenService {
  final Api api = Api();
  final StorageService storageService = StorageService();
  Timer? _timer;

  /// 🔹 استدعاء لمرة واحدة لتجديد التوكن
  Future<String?> refreshAccessToken() async {
    try {
      final refresh = await storageService.getRefreshToken();
      print("🟢 Current refresh token: $refresh");

      if (refresh == null || refresh.isEmpty) {
        print("❌ No refresh token saved");
        return null;
      }

      final response = await api.post(
        url: ApiConstants.refreshToken,
        body: {"refresh": refresh},
        token: null,
      );

      final newAccess = response["access"];

      if (newAccess != null) {
        await storageService.resetTokens(newAccess);
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

  /// 🔹 تشغيل التجديد التلقائي كل 5 دقايق
  void startAutoRefresh() {
    // لو فيه تايمر قديم، نوقفه
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      print("⏳ Auto refreshing token...");
      await refreshAccessToken();
    });
  }

  /// 🔹 إيقاف التجديد التلقائي (مثلاً عند تسجيل الخروج)
  void stopAutoRefresh() {
    _timer?.cancel();
    _timer = null;
  }
}
