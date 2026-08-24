
import 'package:medtech_project/features/interested_product/data/models/interested_product_response.dart';

abstract class InterestedProductRepository {
  Future<InterestedProductData> getInterestedProducts({
    required int page,
    required int pageSize,
  });
}