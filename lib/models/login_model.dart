class LoginModel {
  final String usernameOrEmail;
  final String password;

  LoginModel({
    required this.usernameOrEmail,
    required this.password,
  });

  // تحويل الموديل لـ JSON (لإرساله للباكيند)
  Map<String, dynamic> toJson() {
    return {
      'username_or_email': usernameOrEmail,
      'password': password,
    };
  }
}
