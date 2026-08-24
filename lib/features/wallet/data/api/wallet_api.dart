import 'package:dio/dio.dart';
import 'package:medtech_project/core/services/api_services.dart';

class WalletApi {
  final ApiService apiService;

  WalletApi({required this.apiService});

  Future<Response> getWalletTransactions({int page = 1, int limit = 10}) async {
    try {
      final response = await apiService.dio.get(
        '/api/v1/partner/wallet/transactions',
        queryParameters: {'page': page, 'limit': limit},
      );

      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
