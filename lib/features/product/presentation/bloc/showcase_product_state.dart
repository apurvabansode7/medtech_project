import 'package:medtech_project/features/product/data/models/showcase_product_model.dart';


abstract class ShowcaseProductState {
  const ShowcaseProductState();
}

class ShowcaseProductInitial extends ShowcaseProductState {
  const ShowcaseProductInitial();
}

class ShowcaseProductLoading extends ShowcaseProductState {
  const ShowcaseProductLoading();
}

class ShowcaseProductLoaded extends ShowcaseProductState {
  final List<ShowcaseProduct> products;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool isLoadingMore;

  const ShowcaseProductLoaded({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  ShowcaseProductLoaded copyWith({
    List<ShowcaseProduct>? products,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ShowcaseProductLoaded(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ShowcaseProductFailure extends ShowcaseProductState {
  final String message;

  const ShowcaseProductFailure(this.message);
}