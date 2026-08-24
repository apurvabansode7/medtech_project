import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medtech_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:medtech_project/features/auth/data/api/auth_api.dart';
import 'package:medtech_project/utils/app_prefrences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi authApi;

  AuthRepositoryImpl({
    required this.authApi,
  });

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authApi.login(
        email: email,
        password: password,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        final data = response.data['data'];

        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        await AppPreferences.setAccessToken(accessToken);
        await AppPreferences.setRefreshToken(refreshToken);
        await AppPreferences.setLoggedIn(true);

        return;
      }

      throw Exception(
        response.data?['message'] ?? 'Login failed',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    }
  }

  @override
Future<void> logout() async {
  try {
    final response = await authApi.logout();

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      await AppPreferences.logout();
      return;
    }

    throw Exception(
      response.data?['message'] ?? 'Logout failed',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
  }
}

  @override
  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await authApi.forgotPassword(
        email: email,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return;
      }

      throw Exception(
        response.data?['message'] ??
            'Failed to send OTP',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    }
  }
@override
Future<String> verifyOtp({
  required String email,
  required String otp,
}) async {
  try {
    final response = await authApi.verifyOtp(
      email: email,
      otp: otp,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      final data = response.data['data'];

      if (data == null) {
        throw Exception('OTP response data not found');
      }

      // Backend returns "optId"
      final optId = data['optId'];

      if (optId == null || optId.toString().isEmpty) {
        throw Exception('OTP ID not received');
      }

      debugPrint('OTP verified');
      debugPrint('optId: $optId');

      return optId.toString();
    }

    throw Exception(
      response.data?['message'] ??
          'OTP verification failed',
    );
  } on DioException catch (e) {
    debugPrint('VERIFY OTP ERROR: ${e.response?.data}');

    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
  }
}

  @override
Future<void> resendOtp({
  required String email,
}) async {
  try {
    final response = await authApi.resendOtp(
      email: email,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return;
    }

    throw Exception(
      response.data?['message'] ??
          'Failed to resend OTP',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
  }
}
@override
Future<void> setPassword({
  required String otpId,
  required String password,
  required String confirmPassword,
}) async {
  try {
    final response = await authApi.setPassword(
      otpId: otpId,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return;
    }

    throw Exception(
      response.data?['message'] ?? 'Failed to set password',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
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

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return;
      }

      throw Exception(
        response.data?['message'] ??
            'Password reset failed',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    }
  }

}