import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/showcase_product_repository.dart';
import 'product_interest_event.dart';
import 'product_interest_state.dart';

class ProductInterestBloc
    extends Bloc<ProductInterestEvent, ProductInterestState> {
  final ShowcaseProductRepository repository;

  ProductInterestBloc({
    required this.repository,
  }) : super(const ProductInterestInitial()) {
    on<SubmitProductInterest>(_onSubmitProductInterest);
  }

  Future<void> _onSubmitProductInterest(
    SubmitProductInterest event,
    Emitter<ProductInterestState> emit,
  ) async {
    emit(const ProductInterestLoading());

    try {
      await repository.submitProductInterest(
        productId: event.productId,
        quantityRequested: event.quantityRequested,
        note: event.note,
      );

      emit(
        const ProductInterestSuccess(
          message: 'Product interest submitted successfully',
        ),
      );
    } catch (e) {
      emit(
        ProductInterestFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}