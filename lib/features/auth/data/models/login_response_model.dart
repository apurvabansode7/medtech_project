class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final bool mustChangePassword;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.mustChangePassword,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      mustChangePassword: json['mustChangePassword'] ?? false,
    );
  }
}