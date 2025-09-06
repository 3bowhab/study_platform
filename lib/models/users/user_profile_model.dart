class UserProfileModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String userType; // student, parent, teacher
  final String phoneNumber;
  // final String profilePicture;
  final String dateOfBirth;
  final String bio;
  final String address;
  final String city;
  final String country;
  final bool emailVerified;
  final String dateJoined;
  final String lastLogin;
  final String parentName;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.userType,
    required this.phoneNumber,
    // required this.profilePicture,
    required this.dateOfBirth,
    required this.bio,
    required this.address,
    required this.city,
    required this.country,
    required this.emailVerified,
    required this.dateJoined,
    required this.lastLogin,
    required this.parentName,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json["id"],
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      fullName: json["full_name"] ?? "",
      userType: json["user_type"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      // profilePicture: json["profile_picture"] ?? "",
      dateOfBirth: json["date_of_birth"] ?? "",
      bio: json["bio"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      country: json["country"] ?? "",
      emailVerified: json["email_verified"] ?? false,
      dateJoined: json["date_joined"] ?? "",
      lastLogin: json["last_login"] ?? "",
      parentName: json["parent_name"] ?? "",
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      // "profile_picture": profilePicture,
      "date_of_birth": dateOfBirth,
      "bio": bio,
      "address": address,
      "city": city,
      "country": country,
      "parent_name": parentName,
    };
  }
}
