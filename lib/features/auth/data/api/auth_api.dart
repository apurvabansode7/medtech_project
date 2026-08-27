import 'package:dio/dio.dart';
import 'package:medtech_project/core/services/api_services.dart';

class AuthApi {
  final ApiService apiService;

  AuthApi({required this.apiService});

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await apiService.post(
      '/api/v1/partners-auth/login',
      data: {'email': email, 'password': password},
    );
  }

  // NEW: Login with OTP - only email required
  Future<Response> loginWithOtp({
    required String email,
  }) async {
    return await apiService.post(
      '/api/v1/partners-auth/login-otp',
      data: {
        'email': email,
      },
    );
  }

  Future<Response> forgotPassword({required String email}) async {
    return await apiService.post(
      '/api/v1/otp/forgot-password',
      data: {'userType': 'CHEMIST', 'email': email},
    );
  }

  Future<Response> verifyOtp({
    required String email,
    required String otp,
     // required String accessToken,

  }) async {
    return await apiService.post(
      '/api/v1/otp/verify',
      data: {
        'userType': 'CHEMIST',
        'email': email,
        'purpose': 'LOGIN',
        'otp': otp,
      },
    );
  }

  Future<Response> resendOtp({required String email}) async {
    return await apiService.post(
      '/api/v1/otp/resend',
      data: {
        'userType': 'CHEMIST',
        'email': email,
        'purpose': 'LOGIN',
      },
    );
  }

  Future<Response> resetPassword({
    required String otpId,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await apiService.post(
      '/api/v1/otp/reset-password',
      data: {
        'otpId': otpId,
        'email': email,
        'userType': 'CHEMIST',
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
  }

  Future<Response> setPassword({
    required String password,
    required String confirmPassword,
    required String passwordSetupToken,
  }) async {
    return await apiService.post(
      '/api/v1/partners-auth/set-password',
      data: {'password': password, 'confirmPassword': confirmPassword},
      options: Options(
        headers: {'Authorization': 'Bearer $passwordSetupToken'},
      ),
    );
  }

  Future<Response> logout() async {
    return await apiService.post('/api/v1/auth/logout');
  }
}
