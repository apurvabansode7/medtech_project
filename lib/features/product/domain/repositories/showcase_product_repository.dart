
import 'package:medtech_project/features/product/data/models/showcase_product_model.dart';

abstract class ShowcaseProductRepository {
  Future<ShowcaseProductData> getShowcaseProducts({
    required int page,
    required int pageSize,
  });

   Future<void> submitProductInterest({
    required String productId,
    required int quantityRequested,
    required String note,
  });
}