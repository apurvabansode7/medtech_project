abstract class ProductInterestEvent {
  const ProductInterestEvent();
}

class SubmitProductInterest extends ProductInterestEvent {
  final String productId;
  final int quantityRequested;
  final String note;

  const SubmitProductInterest({
    required this.productId,
    required this.quantityRequested,
    required this.note,
  });
}