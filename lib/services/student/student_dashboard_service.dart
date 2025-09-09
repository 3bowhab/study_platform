import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class StudentDashboardService {
  Future<dynamic> getStudentDashboard() async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        throw Exception("❌ No token found, please login again.");
      }

      final response = await _api.get(
        url: ApiConstants.studentDashboard,
        token: token,
      );

      print("✅ Student dashboard fetched successfully: $response");
      return response; // مؤقتًا dynamic لحد ما نحدد الـ Model
    } catch (e) {
      print("❌ Failed to fetch student dashboard: $e");
      rethrow;
    }
  }
}
