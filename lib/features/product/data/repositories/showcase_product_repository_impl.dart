import 'package:dio/dio.dart';
import 'package:medtech_project/features/product/data/api/showcase_product_api.dart';
import 'package:medtech_project/features/product/data/models/showcase_product_model.dart';
import 'package:medtech_project/features/product/domain/repositories/showcase_product_repository.dart';


class ShowcaseProductRepositoryImpl
    implements ShowcaseProductRepository {
  final ShowcaseProductApi api;

  ShowcaseProductRepositoryImpl({
    required this.api,
  });

  @override
  Future<ShowcaseProductData> getShowcaseProducts({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await api.getShowcaseProducts(
        page: page,
        pageSize: pageSize,
      );

      if (response.statusCode == 200) {
        final result = ShowcaseProductResponse.fromJson(
          response.data,
        );

        return result.data;
      }

      throw Exception(
        response.data?['message'] ??
            'Failed to load showcase products',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    }
  }
  @override
Future<void> submitProductInterest({
  required String productId,
  required int quantityRequested,
  required String note,
}) async {
  try {
    final response = await api.submitProductInterest(
      productId: productId,
      quantityRequested: quantityRequested,
      note: note,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return;
    }

    throw Exception(
      response.data?['message'] ??
          'Failed to submit product interest',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
  }
}
}