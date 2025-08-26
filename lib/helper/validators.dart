class AppValidators {
  /// Required field
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }

  /// Email validator
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  /// Password validator
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one number";
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return "Password must contain at least one special character (!@#\$&*~)";
    }
    return null; // valid
  }

  /// Username validator
  static String? confirmPasswordValidator(String? value, String originalPassword) {
    if (value != originalPassword) {
      return "Passwords do not match";
    }
    return null;
  }

  /// Phone number validator
  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return "Enter a valid phone number";
    }
    return null;
  }

  /// Username validator
  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Username is required";
    }
    if (value.length < 3) {
      return "Username must be at least 3 characters";
    }
    return null;
  }
}
