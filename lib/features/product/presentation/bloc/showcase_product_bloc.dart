import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/product/domain/repositories/showcase_product_repository.dart';
import 'showcase_product_event.dart';
import 'showcase_product_state.dart';

class ShowcaseProductBloc
    extends Bloc<ShowcaseProductEvent, ShowcaseProductState> {
  final ShowcaseProductRepository repository;

  static const int pageSize = 10;

  ShowcaseProductBloc({
    required this.repository,
  }) : super(const ShowcaseProductInitial()) {
    on<LoadShowcaseProducts>(_onLoadProducts);
    on<LoadMoreShowcaseProducts>(_onLoadMore);
  on<RefreshShowcaseProducts>(_onRefreshShowcaseProducts);
  }

  Future<void> _onLoadProducts(
    LoadShowcaseProducts event,
    Emitter<ShowcaseProductState> emit,
  ) async {
    emit(const ShowcaseProductLoading());

    try {
      final data = await repository.getShowcaseProducts(
        page: 1,
        pageSize: pageSize,
      );

      emit(
        ShowcaseProductLoaded(
          products: data.items,
          currentPage: data.currentPage,
          totalPages: data.totalPages,
          hasMore: false
          
        ),
      );
    } catch (e) {
      emit(
        ShowcaseProductFailure(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    LoadMoreShowcaseProducts event,
    Emitter<ShowcaseProductState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ShowcaseProductLoaded) {
      return;
    }

    if (!currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    emit(
      currentState.copyWith(
        isLoadingMore: true,
      ),
    );

    try {
      final nextPage = currentState.currentPage + 1;

      final data = await repository.getShowcaseProducts(
        page: nextPage,
        pageSize: pageSize,
      );

      final updatedProducts = [
        ...currentState.products,
        ...data.items,
      ];

      emit(
        ShowcaseProductLoaded(
          products: updatedProducts,
          currentPage: data.currentPage,
          totalPages: data.totalPages,
          hasMore: false
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isLoadingMore: false,
        ),
      );
    }
  }
Future<void> _onRefreshShowcaseProducts(
  RefreshShowcaseProducts event,
  Emitter<ShowcaseProductState> emit,
) async {
  try {
    final data = await repository.getShowcaseProducts(
      page: 1,
      pageSize: 10,
    );

    emit(
      ShowcaseProductLoaded(
        products: data.items,
        currentPage: data.currentPage,
        totalPages: data.totalPages,
        hasMore: data.currentPage < data.totalPages,
        isLoadingMore: false,
      ),
    );
  } catch (e) {
    emit(
      ShowcaseProductFailure(
        e.toString().replaceFirst('Exception: ', ''),
      ),
    );
  }
}
}