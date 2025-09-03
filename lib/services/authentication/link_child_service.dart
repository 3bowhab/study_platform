import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';

class LinkChildService {
  final Api api = Api();
  final StorageService storageService = StorageService();


  Future<void> linkChild(String childUsername) async {
    try {
            // 🟢 هات التوكين من الـ Storage
      final token = await storageService.getAccessToken();

      if (token == null) {
        throw Exception("No token found, user might not be logged in.");
      }
      
      final response = await api.post(

        url: ApiConstants.linkChild,
        body: {"child_username": childUsername},
        token: token,
      );

      print("✅ Response from API (link child): $response");

    } catch (e) {
      throw Exception("❌ Unexpected Error: $e");
    }
  }
}
