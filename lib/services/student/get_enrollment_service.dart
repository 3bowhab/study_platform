import 'package:study_platform/helper/api.dart';
import 'package:study_platform/helper/api_constants.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/models/student_models/enrollment_model.dart';

final Api _api = Api();
final StorageService storageService = StorageService();

class GetEnrollmentService {
  Future<List<EnrollmentModel>> getStudentEnrollments() async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) throw Exception("❌ No token found");

      final response = await _api.get(
        url: ApiConstants.studentEnrollments,
        token: token,
      );

      print("✅ Enrollments fetched successfully");

      final List<dynamic> data = response;
      return data.map((json) => EnrollmentModel.fromJson(json)).toList();
    } catch (e) {
      print("❌ Failed to fetch enrollments: $e");
      rethrow;
    }
  }
}
