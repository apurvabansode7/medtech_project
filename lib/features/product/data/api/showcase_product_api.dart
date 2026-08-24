import 'package:dio/dio.dart';
import 'package:medtech_project/core/services/api_services.dart';

class ShowcaseProductApi {
  final ApiService apiService;

  ShowcaseProductApi({
    required this.apiService,
  });

  Future<Response> getShowcaseProducts({
    required int page,
    required int pageSize,
  }) async {
    return await apiService.get(
      '/api/v1/showcase-products',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
  }

  Future<Response> submitProductInterest({
    required String productId,
    required int quantityRequested,
    required String note,
  }) async {
    return await apiService.post(
      '/api/v1/showcase-products/$productId/interests',
      data: {
        'quantityRequested': quantityRequested,
        'note': note,
      },
    );
  }
}