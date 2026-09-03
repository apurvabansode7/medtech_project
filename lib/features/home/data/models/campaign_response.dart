import 'package:flutter/material.dart';

class CampaignResponse {
  final bool success;
  final CampaignData data;

  CampaignResponse({
    required this.success,
    required this.data,
  });

  factory CampaignResponse.fromJson(Map<String, dynamic> json) {
    return CampaignResponse(
      success: json['success'] ?? false,
      data: CampaignData.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}

class CampaignData {
  final List<Campaign> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  CampaignData({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  factory CampaignData.fromJson(Map<String, dynamic> json) {
    return CampaignData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => Campaign.fromJson(
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

class Campaign {
  final String id;
  final String referenceId;
  final String code;
  final String name;
  final String description;
  final String type;
  final String status;
  final int priority;
  final String schemeCode;
  final String schemeType;
  final bool isSubscribed;

  final bool applicableToAllProducts;
  final List<String> applicableProducts;

  final int totalDealerPoints;
  final int totalChemistPoints;

  final String? startDate;
  final String? endDate;
  final String? claimEndDate;

  final List<String> partnerTypes;
  final List<String> regionIds;

  final bool autoEnroll;

  final String pointCalculationType;
  final String? pointFromDate;
  final String? pointToDate;

  final String redemptionType;

  final List<CampaignReward> rewards;

  final String? bannerImage;
  final String? thumbnailImage;

  final bool isFeatured;
  final String termsAndConditions;

  Campaign({
    required this.id,
    required this.referenceId,
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.priority,
    required this.schemeCode,
    required this.schemeType,
    required this.isSubscribed,
    required this.applicableToAllProducts,
    required this.applicableProducts,
    required this.totalDealerPoints,
    required this.totalChemistPoints,
    required this.startDate,
    required this.endDate,
    required this.claimEndDate,
    required this.partnerTypes,
    required this.regionIds,
    required this.autoEnroll,
    required this.pointCalculationType,
    required this.pointFromDate,
    required this.pointToDate,
    required this.redemptionType,
    required this.rewards,
    required this.bannerImage,
    required this.thumbnailImage,
    required this.isFeatured,
    required this.termsAndConditions,
  });
  
  factory Campaign.fromJson(Map<String, dynamic> json) {
      debugPrint(
    'CAMPAIGN JSON => '
    'id=${json['id']}, '
    'name=${json['name']}, '
    'isSubscribed=${json['isSubscribed']}',
  );
    return Campaign(
      id: json['id'] ?? '',
      referenceId: json['referenceId'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
    priority: (json['priority'] as num?)?.toInt() ?? 0,
      schemeCode: json['schemeCode'] ?? '',
      schemeType: json['schemeType'] ?? '',
      isSubscribed:
          json['isSubscribed'] == true ||
          json['subscribed'] == true ||
          json['isEnrolled'] == true,
      applicableToAllProducts:
          json['applicableToAllProducts'] ?? false,
    applicableProducts:
    (json['applicableProducts'] as List?)
        ?.whereType<String>()
        .toList() ??
    [],
      // totalDealerPoints:
      //     json['totalDealerPoints'] ?? 0,
      // totalChemistPoints:
      //     json['totalChemistPoints'] ?? 0,
      totalDealerPoints: (json['totalDealerPoints'] as num?)?.toInt() ?? 0,
totalChemistPoints: (json['totalChemistPoints'] as num?)?.toInt() ?? 0,
      startDate: json['startDate'],
      endDate: json['endDate'],
      claimEndDate: json['claimEndDate'],
    partnerTypes:
    (json['partnerTypes'] as List?)
        ?.whereType<String>()
        .toList() ??
    [],
     regionIds:
    (json['regionIds'] as List?)
        ?.whereType<String>()
        .toList() ??
    [],
      autoEnroll:
          json['autoEnroll'] ?? false,
      pointCalculationType:
          json['pointCalculationType'] ?? '',
      pointFromDate: json['pointFromDate'],
      pointToDate: json['pointToDate'],
      redemptionType:
          json['redemptionType'] ?? '',
      rewards:
          (json['rewards'] as List<dynamic>? ?? [])
              .map(
                (item) => CampaignReward.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
      bannerImage: json['bannerImage'],
      thumbnailImage: json['thumbnailImage'],
      isFeatured:
          json['isFeatured'] ?? false,
      termsAndConditions:
          json['termsAndConditions'] ?? '',
    );
  }
}

class CampaignReward {
  final String rewardId;
  final RewardProduct? rewardProduct;

  final int chemistPoints;
  final int dealerPoints;

  final int stock;
  final int claimedStock;
  final int perUserLimit;

  final int displayOrder;
  final bool isActive;

  CampaignReward({
    required this.rewardId,
    required this.rewardProduct,
    required this.chemistPoints,
    required this.dealerPoints,
    required this.stock,
    required this.claimedStock,
    required this.perUserLimit,
    required this.displayOrder,
    required this.isActive,
  });

  factory CampaignReward.fromJson(
    Map<String, dynamic> json,
  ) {
    return CampaignReward(
      rewardId: json['rewardId'] ?? '',
      rewardProduct:
          json['rewardProduct'] != null
              ? RewardProduct.fromJson(
                  json['rewardProduct'],
                )
              : null,
    chemistPoints: (json['chemistPoints'] as num?)?.toInt() ?? 0,
dealerPoints: (json['dealerPoints'] as num?)?.toInt() ?? 0,
stock: (json['stock'] as num?)?.toInt() ?? 0,
claimedStock: (json['claimedStock'] as num?)?.toInt() ?? 0,
perUserLimit: (json['perUserLimit'] as num?)?.toInt() ?? 0,
displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      isActive:
          json['isActive'] ?? false,
    );
  }
}

class RewardProduct {
  final String id;
  final String rewardProductId;
  final String name;
  final String description;
  final String brand;
  final List<String> images;
  final List<String> visibleTo;
  final int availableQuantity;
  final bool isActive;

  RewardProduct({
    required this.id,
    required this.rewardProductId,
    required this.name,
    required this.description,
    required this.brand,
    required this.images,
    required this.visibleTo,
    required this.availableQuantity,
    required this.isActive,
  });

  factory RewardProduct.fromJson(
    Map<String, dynamic> json,
  ) {
    return RewardProduct(
      id: json['id'] ?? '',
      rewardProductId:
          json['rewardProductId'] ?? '',
      name: json['name'] ?? '',
      description:
          json['description'] ?? '',
      brand: json['brand'] ?? '',
      images:
          (json['images'] as List?)
              ?.whereType<String>()
              .toList() ??
          [],
     visibleTo:
    (json['visibleTo'] as List?)
        ?.whereType<String>()
        .toList() ??
    [],
      availableQuantity:
          json['availableQuantity'] ?? 0,
      isActive:
          json['isActive'] ?? false,
    );
  }
}