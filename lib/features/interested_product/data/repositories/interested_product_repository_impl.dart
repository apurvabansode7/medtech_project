import 'package:dio/dio.dart';
import 'package:medtech_project/features/interested_product/data/api/interested_product_api.dart';
import 'package:medtech_project/features/interested_product/data/models/interested_product_response.dart';
import 'package:medtech_project/features/interested_product/domain/repositories/interested_product_repository.dart';


class InterestedProductRepositoryImpl
    implements InterestedProductRepository {
  final InterestedProductApi api;

  InterestedProductRepositoryImpl({
    required this.api,
  });

  @override
  Future<InterestedProductData> getInterestedProducts({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await api.getInterestedProducts(
        page: page,
        pageSize: pageSize,
      );

      if (response.statusCode == 200) {
        final result = InterestedProductResponse.fromJson(
          response.data,
        );

        return result.data;
      }

      throw Exception(
        response.data?['message'] ??
            'Failed to load interested products',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    }
  }
}