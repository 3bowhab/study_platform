class ApiConstants {
  // الـ Base URL الأساسي
  static const String baseUrl =
      "https://educational-platform-git-main-youssefs-projects-e2c35ebf.vercel.app";

  // مسارات الـ Endpoints
  static const String login = "$baseUrl/user/login/";
  static const String register = "$baseUrl/user/register/";
  static const String verifyEmail = "$baseUrl/user/verify-email";
  static const String passwordResetRequest = "$baseUrl/user/password-reset/request/";
  static const String changepassword = "$baseUrl/user/change-password/";
  static const String passwordResetConfirm = "$baseUrl/user/password-reset/confirm";
  static const String deleteAccount = "$baseUrl/user/delete-account/";
  static const String logout = "$baseUrl/user/logout/";
}
