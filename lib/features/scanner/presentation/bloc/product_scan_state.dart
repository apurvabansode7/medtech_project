
abstract class ProductScanState {}

class ProductScanInitial extends ProductScanState {}

class ProductScanLoading extends ProductScanState {}

class ProductScanSuccess extends ProductScanState {
  final String message;
  final bool isAwarded;
  final int? rewardPoints;
  final String? productName;
  final dynamic campaignReward;
  final num? distanceFromTaggedLocation;

  ProductScanSuccess({
    required this.message,
    required this.isAwarded,
    this.productName,
    this.rewardPoints,
    this.campaignReward,
    this.distanceFromTaggedLocation,
  });
}

class ProductScanFailure extends ProductScanState {
  final String message;

  ProductScanFailure({
    required this.message,
  });
}