abstract class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<String> loginOtp({
    required String email,
    // required String deviceId,
    // required String appVersion,
  });

  Future<void> logout();

  Future<void> forgotPassword({required String email});

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    required String deviceId,
    required String appVersion,
      required String platform,
  });

  Future<void> resendOtp({
    required String email,
    required String deviceId,
    required String appVersion,
  });

  Future<void> setPassword({
    required String password,
    required String confirmPassword,
    required String passwordSetupToken,
  });

  Future<void> resetPassword({
    required String otpId,
    required String email,
    required String password,
    required String confirmPassword,
  });
}
