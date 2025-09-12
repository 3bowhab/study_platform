class ApiConstants {
  // الـ Base URL الأساسي
  static const String baseUrl =
      "https://educational-platform-git-main-youssefs-projects-e2c35ebf.vercel.app";

  // user Endpoints
  static const String refreshToken = "$baseUrl/user/token/refresh/";
  static const String login = "$baseUrl/user/login/";
  static const String register = "$baseUrl/user/register/";
  static const String verifyEmail = "$baseUrl/user/verify-email";
  static const String passwordResetRequest = "$baseUrl/user/password-reset/request/";
  static const String changepassword = "$baseUrl/user/change-password/";
  static const String passwordResetConfirm = "$baseUrl/user/password-reset/confirm";
  static const String deleteAccount = "$baseUrl/user/delete-account/";
  static const String logout = "$baseUrl/user/logout/";
  static const String linkChild = "$baseUrl/user/link-child/";
  static const String resendVerificationEmail = "$baseUrl/user/resend-verification-email/";
  static const String userProfile = "$baseUrl/user/profile/";
  static const String studentProfile = "$baseUrl/user/profile/student/";
  static const String parentProfile = "$baseUrl/user/profile/parent/";
  static const String teacherProfile = "$baseUrl/user/profile/teacher/";

  // student endpoints
  static const String studentDashboard = "$baseUrl/student/dashboard/";
  static const String studentGetAllCourses = "$baseUrl/student/get-all-courses/";
  static const String studentEnrollments = "$baseUrl/student/enrollments/";
  static const String studentEnrollTemporaryBase = "$baseUrl/student/enroll/temporary/";
  static const String studentMyCourses = "$baseUrl/student/my-courses/";
  static const String studentCourseInfo = "$baseUrl/student/course/";
}
