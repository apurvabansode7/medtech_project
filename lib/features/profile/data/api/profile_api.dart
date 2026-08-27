import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medtech_project/core/services/api_services.dart';

class ProfileApi {
  final ApiService apiService;

  ProfileApi({
    required this.apiService,
  });

  Future<Response> getProfile() async {
    return await apiService.get(
      '/api/v1/partners/me',
      queryParameters: {},
    );
  }
  //update profile
  //   Future<Response> updateProfile({
  //   required Map<String, dynamic> data,
  // }) async {
  //   return await apiService.put(
  //     '/api/v1/partners/me',
  //     data: data,
  //   );
    
  // }
  Future<Response> updateProfile({
  required Map<String, dynamic> data,
}) async {
  final response = await apiService.put(
    '/api/v1/partners/me',
    data: data,
  );

  debugPrint('UPDATE PROFILE RESPONSE: ${response.data}');

  return response;
}
}