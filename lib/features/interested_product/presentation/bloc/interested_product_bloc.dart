import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/interested_product/domain/repositories/interested_product_repository.dart';

import 'interested_product_event.dart';
import 'interested_product_state.dart';

class InterestedProductBloc
    extends Bloc<InterestedProductEvent, InterestedProductState> {
  final InterestedProductRepository repository;

  static const int pageSize = 10;

  InterestedProductBloc({
    required this.repository,
  }) : super(InterestedProductInitial()) {
    on<LoadInterestedProducts>(
      _onLoadInterestedProducts,
    );

    on<LoadMoreInterestedProducts>(
      _onLoadMoreInterestedProducts,
    );
  }
Future<void> _onLoadInterestedProducts(
  LoadInterestedProducts event,
  Emitter<InterestedProductState> emit,
) async {
  emit(InterestedProductLoading());

  try {
    final data = await repository.getInterestedProducts(
      page: 1,
      pageSize: pageSize,
    );

    emit(
      InterestedProductSuccess(
        products: data.items,
        currentPage: data.currentPage,
        totalPages: data.totalPages,
        hasMore: data.currentPage < data.totalPages,
      ),
    );
  } catch (e) {
    emit(
      InterestedProductFailure(
        message: e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      ),
    );
  }
}

  Future<void> _onLoadMoreInterestedProducts(
    LoadMoreInterestedProducts event,
    Emitter<InterestedProductState> emit,
  ) async {
    final currentState = state;

    if (currentState is! InterestedProductSuccess) {
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
      final nextPage =
          currentState.currentPage + 1;

      final data =
          await repository.getInterestedProducts(
        page: nextPage,
        pageSize: pageSize,
      );

      emit(
        InterestedProductSuccess(
          products: [
            ...currentState.products,
            ...data.items,
          ],
          currentPage: data.currentPage,
          totalPages: data.totalPages,
          hasMore:
              data.currentPage < data.totalPages,
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
}