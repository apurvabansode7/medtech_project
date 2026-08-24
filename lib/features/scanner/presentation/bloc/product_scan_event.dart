abstract class ProductScanEvent {}

class ProductScanSubmitted extends ProductScanEvent {
  final String code;
  final double latitude;
  final double longitude;
  final String deviceUuid;
  final String deviceInfo;
  final String appVersion;

  ProductScanSubmitted({
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.deviceUuid,
    required this.deviceInfo,
    required this.appVersion,
  });
}