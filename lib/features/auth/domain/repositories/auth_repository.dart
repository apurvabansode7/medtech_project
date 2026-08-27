abstract class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

Future<String> loginOtp({required String email});
  Future<void> logout();

  Future<void> forgotPassword({required String email});

  //Future<String> verifyOtp({required String email, required String otp});
 Future<Map<String, dynamic>> verifyOtp({
  required String email,
  required String otp,
 // required String accessToken,
});
  Future<void> resendOtp({required String email});

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
