abstract class ProductInterestState {
  const ProductInterestState();
}

class ProductInterestInitial extends ProductInterestState {
  const ProductInterestInitial();
}

class ProductInterestLoading extends ProductInterestState {
  const ProductInterestLoading();
}

class ProductInterestSuccess extends ProductInterestState {
  final String message;

  const ProductInterestSuccess({
    required this.message,
  });
}

class ProductInterestFailure extends ProductInterestState {
  final String message;

  const ProductInterestFailure({
    required this.message,
  });
}