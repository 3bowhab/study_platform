import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/services/account/parent_profile_service.dart';
import 'package:study_platform/services/account/student_profile_service.dart';
import 'package:study_platform/services/account/teacher_profile_service.dart';


class ProfileRepository {
  final StorageService _storageService = StorageService();

  final StudentProfileService _studentService = StudentProfileService();
  final TeacherProfileService _teacherService = TeacherProfileService();
  final ParentProfileService _parentService = ParentProfileService();

  Future<dynamic> getUserProfile() async {
    try {
      final userType = await _storageService.getUserType();

      if (userType == null) {
        throw Exception("❌ User type not found in storage");
      }

      switch (userType.toLowerCase()) {
        case "student":
          return await _studentService.getStudentProfile();
        case "teacher":
          return await _teacherService.getTeacherProfile();
        case "parent":
          return await _parentService.getParentProfile();
        default:
          throw Exception("❌ Unsupported user type: $userType");
      }
    } catch (e) {
      print("❌ Failed to fetch user profile: $e");
      rethrow;
    }
  }
}
