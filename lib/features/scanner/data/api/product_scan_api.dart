import 'package:dio/dio.dart';
import 'package:medtech_project/core/services/api_services.dart';

class ProductScanApi {
  final ApiService apiService;

  ProductScanApi({required this.apiService});

  Future<Response> scanProduct({
    required String code,
    required double latitude,
    required double longitude,
    required String deviceUuid,
    required String deviceInfo,
    required String appVersion,
  }) async {
    try {
      final response = await apiService.post(
        '/api/v1/product-scan',
        data: {
          'code': code,
          'latitude': latitude,
          'longitude': longitude,
          'deviceUuid': deviceUuid,
          'deviceInfo': deviceInfo,
          'appVersion': appVersion,
        },
      );

      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
