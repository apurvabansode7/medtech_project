abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> logout();

  Future<void> forgotPassword({required String email});

  Future<String> verifyOtp({required String email, required String otp});
  Future<void> resendOtp({required String email});

  Future<void> setPassword({
    required String otpId,
    required String password,
    required String confirmPassword,
  });
  Future<void> resetPassword({
    required String otpId,
    required String email,
    required String password,
    required String confirmPassword,
  });
}
