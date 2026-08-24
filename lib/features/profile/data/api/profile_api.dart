import 'package:dio/dio.dart';
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
}