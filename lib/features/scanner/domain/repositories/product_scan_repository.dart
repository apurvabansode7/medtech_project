abstract class ProductScanRepository {
  Future<Map<String, dynamic>> scanProduct({
    required String code,
    required double latitude,
    required double longitude,
    required String deviceUuid,
    required String deviceInfo,
    required String appVersion,
  });
}