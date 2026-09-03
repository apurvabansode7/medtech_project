class CampaignEarningsResponse {
  final bool success;
  final CampaignEarningsData data;

  CampaignEarningsResponse({
    required this.success,
    required this.data,
  });

  factory CampaignEarningsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CampaignEarningsResponse(
      success: json['success'] ?? false,
      data: CampaignEarningsData.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}

class CampaignEarningsData {
  final String campaignId;
  final String schemeType;
  final int pointsAvailable;
  final List<CampaignEarningItem> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  CampaignEarningsData({
    required this.campaignId,
    required this.schemeType,
    required this.pointsAvailable,
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  factory CampaignEarningsData.fromJson(
    Map<String, dynamic> json,
  ) {
    return CampaignEarningsData(
      campaignId: json['campaignId'] ?? '',
      schemeType: json['schemeType'] ?? '',
      pointsAvailable: json['pointsAvailable'] ?? 0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => CampaignEarningItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
    );
  }
}

class CampaignEarningItem {
  final String userId;
  final String walletId;
  final String type;
  final int points;
  final String reason;
  final String refId;
  final String refType;
  final String pool;
  final List<String> schemeIds;
  final int balanceBefore;
  final int balanceAfter;
  final DateTime? createdAt;
  final String id;
  final String transactionType;
  final DateTime? expiryDate;

  CampaignEarningItem({
    required this.userId,
    required this.walletId,
    required this.type,
    required this.points,
    required this.reason,
    required this.refId,
    required this.refType,
    required this.pool,
    required this.schemeIds,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.createdAt,
    required this.id,
    required this.transactionType,
    required this.expiryDate,
  });

  factory CampaignEarningItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return CampaignEarningItem(
      userId: json['userId'] ?? '',
      walletId: json['walletId'] ?? '',
      type: json['type'] ?? '',
      points: json['points'] ?? 0,
      reason: json['reason'] ?? '',
      refId: json['refId'] ?? '',
      refType: json['refType'] ?? '',
      pool: json['pool'] ?? '',
      schemeIds: List<String>.from(
        json['schemeIds'] ?? [],
      ),
      balanceBefore: json['balanceBefore'] ?? 0,
      balanceAfter: json['balanceAfter'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      id: json['id'] ?? '',
      transactionType: json['transactionType'] ?? '',
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
    );
  }
}