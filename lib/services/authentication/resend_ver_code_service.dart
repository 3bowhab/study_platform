import 'package:dio/dio.dart';
import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';

class ResendVerificationEmailService {
  final Api api = Api();
  final StorageService storageService = StorageService();

  Future<void> resendVerificationEmail() async {
    try {
      // 🟢 هات الإيميل من الـ Storage
      final email = await storageService.getEmail();

      if (email == null || email.isEmpty) {
        throw Exception("No email found, please login first.");
      }

      final response = await api.post(
        url: ApiConstants.resendVerificationEmail,
        body: {"email": email},
        token: null, // ✨ مش محتاج توكن هنا
      );

      print("✅ Response from API (resend verification email): $response");
    } on DioException catch (e) {
      final message = api.handleDioError(e);
      throw Exception(message); // ❌ هترجع للمستخدم الرسالة بس
    } catch (e) {
      throw Exception("❌ Unexpected Error in resendVerificationEmail: $e");
    }
  }
}
