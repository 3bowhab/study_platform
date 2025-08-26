class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String userType;
  final String? phoneNumber;
  final String? profilePicture;
  final String? dateOfBirth;
  final String bio;
  final String address;
  final String city;
  final String country;
  final bool emailVerified;
  final String dateJoined;
  final String lastLogin;
  final String? parentName;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.userType,
    this.phoneNumber,
    this.profilePicture,
    this.dateOfBirth,
    required this.bio,
    required this.address,
    required this.city,
    required this.country,
    required this.emailVerified,
    required this.dateJoined,
    required this.lastLogin,
    this.parentName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'] ?? '',
      userType: json['user_type'] ?? '',
      phoneNumber: json['phone_number'],
      profilePicture: json['profile_picture'],
      dateOfBirth: json['date_of_birth'],
      bio: json['bio'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      emailVerified: json['email_verified'] ?? false,
      dateJoined: json['date_joined'] ?? '',
      lastLogin: json['last_login'] ?? '',
      parentName: json['parent_name'],
    );
  }
}
