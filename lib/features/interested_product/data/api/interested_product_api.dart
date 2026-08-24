import 'package:dio/dio.dart';
import 'package:medtech_project/core/services/api_services.dart';

class InterestedProductApi {
  final ApiService apiService;

  InterestedProductApi({
    required this.apiService,
  });

  Future<Response> getInterestedProducts({
    required int page,
    required int pageSize,
  }) async {
    return await apiService.get(
      '/api/v1/partners/me/interested-products',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
  }
}