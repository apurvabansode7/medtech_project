import 'package:medtech_project/features/interested_product/data/models/interested_product_response.dart';

abstract class InterestedProductState {}

class InterestedProductInitial
    extends InterestedProductState {}

class InterestedProductLoading
    extends InterestedProductState {}

class InterestedProductSuccess
    extends InterestedProductState {
  final List<InterestedProduct> products;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool isLoadingMore;

  InterestedProductSuccess({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  InterestedProductSuccess copyWith({
    List<InterestedProduct>? products,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return InterestedProductSuccess(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore:
          isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class InterestedProductFailure
    extends InterestedProductState {
  final String message;

  InterestedProductFailure({
    required this.message,
  });
}