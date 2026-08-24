class ScanHistoryModel {
  final String id;
  final String referenceId;

  final String productCode;
  final String scannedCode;

  final String scannedAt;
  final String scanResult;
  final String scanResultType;
  final String scanStatus;

  final String partnerType;
  final String scanType;

  final String region;
  final String batchNo;

  final int rewardPointsEarned;

  final BusinessDetails businessDetails;

  ScanHistoryModel({
    required this.id,
    required this.referenceId,
    required this.productCode,
    required this.scannedCode,
    required this.scannedAt,
    required this.scanResult,
    required this.scanResultType,
    required this.scanStatus,
    required this.partnerType,
    required this.scanType,
    required this.region,
    required this.batchNo,
    required this.rewardPointsEarned,
    required this.businessDetails,
  });

  factory ScanHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final productDetails =
        json['productDetails'] as Map<String, dynamic>?;

    final businessDetails =
        json['businessDetails'] as Map<String, dynamic>?;

    return ScanHistoryModel(
      id: json['id'] ?? '',
      referenceId: json['referenceId'] ?? '',

      productCode:
          productDetails?['productCode'] ?? '',

      scannedCode:
          json['scannedCode'] ?? '',

      scannedAt:
          json['scannedAt'] ?? '',

      scanResult:
          json['scanResult'] ?? '',

      scanResultType:
          json['scanResultType'] ?? '',

      scanStatus:
          json['scanStatus'] ?? '',

      partnerType:
          json['partnerType'] ?? '',

      scanType:
          json['scanType'] ?? '',

      region:
          json['region'] ?? '',

      batchNo:
          json['batchNo'] ?? '',

      rewardPointsEarned:
          json['rewardPointsEarned'] is num
              ? (json['rewardPointsEarned'] as num).toInt()
              : 0,

      businessDetails:
          BusinessDetails.fromJson(
        businessDetails ?? {},
      ),
    );
  }
}

class BusinessDetails {
  final String businessName;
  final String partnerName;
  final String outletName;
  final String outletUserName;

  BusinessDetails({
    required this.businessName,
    required this.partnerName,
    required this.outletName,
    required this.outletUserName,
  });

  factory BusinessDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return BusinessDetails(
      businessName:
          json['businessName'] ?? '',
      partnerName:
          json['partnerName'] ?? '',
      outletName:
          json['outletName'] ?? '',
      outletUserName:
          json['outletUserName'] ?? '',
    );
  }
}

class ScanHistoryResponse {
  final List<ScanHistoryModel> scans;
  final int currentPage;
  final int totalPages;

  ScanHistoryResponse({
    required this.scans,
    required this.currentPage,
    required this.totalPages,
  });
}