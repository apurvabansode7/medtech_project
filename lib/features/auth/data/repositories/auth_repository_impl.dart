import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medtech_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:medtech_project/features/auth/data/api/auth_api.dart';
import 'package:medtech_project/utils/app_prefrences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi authApi;

  AuthRepositoryImpl({required this.authApi});

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authApi.login(email: email, password: password);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];

        if (data == null) {
          throw Exception('Login response data not found');
        }

        final mustChangePassword = data['mustChangePassword'] ?? false;

        final passwordSetupToken = data['passwordSetupToken'];

        final accessToken = data['accessToken'];

        final refreshToken = data['refreshToken'];

        // Save normal access token if returned
        if (accessToken != null && accessToken.toString().isNotEmpty) {
          await AppPreferences.setAccessToken(accessToken.toString());
        }

        // Save normal refresh token if returned
        if (refreshToken != null && refreshToken.toString().isNotEmpty) {
          await AppPreferences.setRefreshToken(refreshToken.toString());
        }
              await AppPreferences.setLoggedIn(true);
        return {
          'mustChangePassword': mustChangePassword,
          'passwordSetupToken': passwordSetupToken?.toString(),
        };
      }

      throw Exception(response.data?['message'] ?? 'Login failed');
    } on DioException catch (e) {
      debugPrint('Login Error: ${e.response?.data}');

      throw Exception(e.response?.data?['message'] ?? 'Something went wrong');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await authApi.logout();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await AppPreferences.logout();
        return;
      }

      throw Exception(response.data?['message'] ?? 'Logout failed');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Something went wrong');
    }
  }@override
Future<String> loginOtp({required String email}) async {
  try {
    final response = await authApi.loginWithOtp(
      email: email,
    );

    debugPrint('LOGIN OTP RESPONSE: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'OTP sent successfully';
    }

    throw Exception(
      response.data?['message'] ?? 'Failed to send OTP',
    );
  } on DioException catch (e) {
    debugPrint('LOGIN OTP ERROR: ${e.response?.data}');

    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
  }
}

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await authApi.forgotPassword(email: email);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception(response.data?['message'] ?? 'Failed to send OTP');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Something went wrong');
    }
  }

  // @override
  // Future<String> verifyOtp({required String email, required String otp}) async {
  //   try {
  //     final response = await authApi.verifyOtp(email: email, otp: otp);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = response.data['data'];

  //       if (data == null) {
  //         throw Exception('OTP response data not found');
  //       }

  //       // Backend returns "optId"
  //       final optId = data['optId'];

  //       if (optId == null || optId.toString().isEmpty) {
  //         throw Exception('OTP ID not received');
  //       }

  //       return optId.toString();
  //     }

  //     throw Exception(response.data?['message'] ?? 'OTP verification failed');
  //   } on DioException catch (e) {
  //     throw Exception(e.response?.data?['message'] ?? 'Something went wrong');
  //   }
  // }

  @override
Future<Map<String, dynamic>> verifyOtp({
  required String email,
  required String otp,
}) async {
  try {
    final response = await authApi.verifyOtp(
      email: email,
      otp: otp,
    );

    debugPrint('VERIFY OTP RESPONSE: ${response.data}');

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      final data = response.data['data'];

      if (data == null) {
        throw Exception(
          'OTP verification response data not found',
        );
      }

      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];

      if (accessToken == null ||
          accessToken.toString().isEmpty) {
        throw Exception(
          'Access token not received after OTP verification',
        );
      }

      if (refreshToken == null ||
          refreshToken.toString().isEmpty) {
        throw Exception(
          'Refresh token not received after OTP verification',
        );
      }

      // Save final login tokens
      await AppPreferences.setAccessToken(
        accessToken.toString(),
      );

      await AppPreferences.setRefreshToken(
        refreshToken.toString(),
      );

      // User is now actually logged in
      await AppPreferences.setLoggedIn(true);

      return {
        'accessToken': accessToken.toString(),
        'refreshToken': refreshToken.toString(),
        'sessionId': data['sessionId']?.toString(),
      };
    }

    throw Exception(
      response.data?['message'] ??
          'OTP verification failed',
    );
  } on DioException catch (e) {
    debugPrint(
      'Verify OTP Error: ${e.response?.data}',
    );

    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
  }
}
  @override
  Future<void> resendOtp({required String email}) async {
    try {
      final response = await authApi.resendOtp(email: email);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception(response.data?['message'] ?? 'Failed to resend OTP');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Something went wrong');
    }
  }

  @override
  Future<void> setPassword({
    required String password,
    required String confirmPassword,
    required String passwordSetupToken,
  }) async {
    try {
      final response = await authApi.setPassword(
        password: password,
        confirmPassword: confirmPassword,
        passwordSetupToken: passwordSetupToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception(response.data?['message'] ?? 'Failed to set password');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Something went wrong');
    }
  }

  @override
  Future<void> resetPassword({
    required String otpId,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await authApi.resetPassword(
        otpId: otpId,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception(response.data?['message'] ?? 'Password reset failed');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Something went wrong');
    }
  }
}
