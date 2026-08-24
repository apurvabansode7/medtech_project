import 'package:dio/dio.dart';
import 'package:medtech_project/core/services/api_services.dart';

class ScanHistoryApi {
  final ApiService apiService;

  ScanHistoryApi({
    required this.apiService,
  });

   Future<Response> getScanHistory({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.get(
        '/api/v1/product-scan/my',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return response;
    } on DioException {
      rethrow;
    }
  }
}