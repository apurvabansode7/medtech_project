

class PartnerCampaignResponse {
  final bool success;
  final PartnerCampaignData data;

  PartnerCampaignResponse({
    required this.success,
    required this.data,
  });

  factory PartnerCampaignResponse.fromJson(Map<String, dynamic> json) {
    return PartnerCampaignResponse(
      success: json['success'] ?? false,
      data: PartnerCampaignData.fromJson(json['data'] ?? {}),
    );
  }
}

class PartnerCampaignData {
  final List<PartnerCampaign> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  PartnerCampaignData({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  factory PartnerCampaignData.fromJson(Map<String, dynamic> json) {
    return PartnerCampaignData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => PartnerCampaign.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
    );
  }
}

class PartnerCampaign {
  final String campaignId;
  final String referenceId;
  final String code;
  final String name;
  final String description;
  final String type;
  final String schemeType;
  final String status;

  final String? startDate;
  final String? endDate;
  final String? claimEndDate;

  final bool isExpired;
  final String enrollmentStatus;
  final String? enrolledAt;

  final int pointsEarned;
  final int pointsAvailable;

  PartnerCampaign({
    required this.campaignId,
    required this.referenceId,
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    required this.schemeType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.claimEndDate,
    required this.isExpired,
    required this.enrollmentStatus,
    required this.enrolledAt,
    required this.pointsEarned,
    required this.pointsAvailable,
  });

  factory PartnerCampaign.fromJson(Map<String, dynamic> json) {
    return PartnerCampaign(
      campaignId: json['campaignId'] ?? '',
      referenceId: json['referenceId'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      schemeType: json['schemeType'] ?? '',
      status: json['status'] ?? '',
      startDate: json['startDate'],
      endDate: json['endDate'],
      claimEndDate: json['claimEndDate'],
      isExpired: json['isExpired'] ?? false,
      enrollmentStatus: json['enrollmentStatus'] ?? '',
      enrolledAt: json['enrolledAt'],
      pointsEarned: json['pointsEarned'] ?? 0,
      pointsAvailable: json['pointsAvailable'] ?? 0,
    );
  }
}