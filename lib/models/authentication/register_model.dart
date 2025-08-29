class RegisterModel {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String userType;
  final String dateOfBirth;

  RegisterModel({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.userType,
    required this.dateOfBirth,
  });

  // تحويل الموديل لـ JSON (لإرساله للباكيند)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'password_confirm': confirmPassword,
      'first_name': firstname,
      'last_name': lastname,
      'phone_number': phoneNumber,
      'user_type': userType,
      'date_of_birth': dateOfBirth,
    };
  }
}
