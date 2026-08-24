class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your Phone                                   ';
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }

    final phoneRegex = RegExp(r'^\d{10}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid 10 digit phone number';
    }

    return null;
  }

  static String? emailOrPhone(
    String? value,
    bool isPhone,
  ) {
    if (isPhone) {
      return phone(value);
    }

    return email(value);
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least 1 capital letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least 1 small letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least 1 special character';
    }

    if (value.contains(' ')) {
      return 'Password must not contain spaces';
    }

    return null;
  }
}