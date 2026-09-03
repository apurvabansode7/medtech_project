import 'package:flutter/material.dart';

class CampaignRewardsResponse {
  final bool success;
  final CampaignRewardsData data;

  CampaignRewardsResponse({
    required this.success,
    required this.data,
  });

  factory CampaignRewardsResponse.fromJson(Map<String, dynamic> json) {
    return CampaignRewardsResponse(
      success: json['success'] ?? false,
      data: CampaignRewardsData.fromJson(json['data'] ?? {}),
    );
  }
}

class CampaignRewardsData {
  final String campaignId;
  final String name;
  final String schemeType;
  final int pointsAvailable;
  final List<CampaignRewardItem> rewards;

  CampaignRewardsData({
    required this.campaignId,
    required this.name,
    required this.schemeType,
    required this.pointsAvailable,
    required this.rewards,
  });

  factory CampaignRewardsData.fromJson(Map<String, dynamic> json) {
    return CampaignRewardsData(
      campaignId: _parseString(json['campaignId']),
      name: _parseString(json['name']),
      schemeType: _parseString(json['schemeType']),
      pointsAvailable: _parseInt(json['pointsAvailable']),
      rewards: (json['rewards'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((item) => CampaignRewardItem.fromJson(item))
          .toList(),
    );
  }
}

class CampaignRewardItem {
  final String rewardId;
  final String name;
  final String description;
  final String brand;
  final List<String> images;
  final int chemistPoints;
  final int dealerPoints;
  final int stock;
  final int remainingStock;
  final int claimedStock;
  final int perUserLimit;
  final int displayOrder;
  final bool isActive;
  final int pointsRequired;
  final int normalPointsRequired;
  final int schemePointsRequired;
  final int pointsEarned;
  final bool canClaim;
  final RewardProduct? rewardProduct;

  CampaignRewardItem({
    required this.rewardId,
    required this.name,
    required this.description,
    required this.brand,
    required this.images,
    required this.chemistPoints,
    required this.dealerPoints,
    required this.stock,
    required this.remainingStock,
    required this.claimedStock,
    required this.perUserLimit,
    required this.displayOrder,
    required this.isActive,
    required this.pointsRequired,
    required this.normalPointsRequired,
    required this.schemePointsRequired,
    required this.pointsEarned,
    required this.canClaim,
    this.rewardProduct,
  });

  factory CampaignRewardItem.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? productJson;
    if (json['rewardProduct'] is Map<String, dynamic>) {
      productJson = json['rewardProduct'] as Map<String, dynamic>;
    }

    final String rewardId = _parseString(json['rewardId']).isNotEmpty
        ? _parseString(json['rewardId'])
        : _parseString(productJson?['id'] ?? productJson?['rewardProductId']);

    final String name = _parseString(json['name']).isNotEmpty
        ? _parseString(json['name'])
        : _parseString(productJson?['name']);

    final String description = _parseString(json['description']).isNotEmpty
        ? _parseString(json['description'])
        : _parseString(productJson?['description']);

    final String brand = _parseString(json['brand']).isNotEmpty
        ? _parseString(json['brand'])
        : _parseString(productJson?['brand']);

    final List<String> images = _parseStringList(json['images']).isNotEmpty
        ? _parseStringList(json['images'])
        : _parseStringList(productJson?['images']);
debugPrint(
  'WATCH POINT DEBUG => '
  'name=${json['name']} | '
  'pointsRequired=${json['pointsRequired']} | '
  'normalPointsRequired=${json['normalPointsRequired']} | '
  'schemePointsRequired=${json['schemePointsRequired']}',
);
    final int pointsRequired = _parseInt(
      json['schemePointsRequired'] ??
          json['normalPointsRequired'] ??
          json['pointsRequired'],
    );
// final int pointsRequired = _parseInt(
//   json['pointsRequired'] ??
//       json['normalPointsRequired'] ??
      
//       json['schemePointsRequired'],
// );

    final bool canClaim = json['isClaimable'] == true ||
        json['canClaim'] == true;

    return CampaignRewardItem(
      rewardId: rewardId,
      name: name,
      description: description,
      brand: brand,
      images: images,
      chemistPoints: _parseInt(json['chemistPoints']),
      dealerPoints: _parseInt(json['dealerPoints']),
      stock: _parseInt(json['stock'] ?? json['remainingStock']),
      remainingStock: _parseInt(json['remainingStock']),
      claimedStock: _parseInt(json['claimedStock']),
      perUserLimit: _parseInt(json['perUserLimit']),
      displayOrder: _parseInt(json['displayOrder']),
      isActive: json['isActive'] == true,
      pointsRequired: pointsRequired,
      normalPointsRequired: _parseInt(json['normalPointsRequired']),
      schemePointsRequired: _parseInt(json['schemePointsRequired']),
      pointsEarned: _parseInt(json['pointsEarned']),
      canClaim: canClaim,
      rewardProduct:
          productJson != null ? RewardProduct.fromJson(productJson) : null,
    );
  }
}

class RewardProduct {
  final String id;
  final String rewardProductId;
  final String name;
  final String description;
  final String categoryId;
  final dynamic category;
  final String brand;
  final List<String> images;
  final List<String> visibleTo;
  final List<PartnerConfig> partnerConfig;
  final int availableQuantity;
  final bool isActive;
  final String createdBy;
  final String updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RewardProduct({
    required this.id,
    required this.rewardProductId,
    required this.name,
    required this.description,
    required this.categoryId,
    this.category,
    required this.brand,
    required this.images,
    required this.visibleTo,
    required this.partnerConfig,
    required this.availableQuantity,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory RewardProduct.fromJson(Map<String, dynamic> json) {
    return RewardProduct(
      id: _parseString(json['id']),
      rewardProductId: _parseString(json['rewardProductId']),
      name: _parseString(json['name']),
      description: _parseString(json['description']),
      categoryId: _parseString(json['categoryId']),
      category: json['category'],
      brand: _parseString(json['brand']),
      images: _parseStringList(json['images']),
      visibleTo: _parseStringList(json['visibleTo']),
      partnerConfig: (json['partnerConfig'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((item) => PartnerConfig.fromJson(item))
          .toList(),
      availableQuantity: _parseInt(json['availableQuantity']),
      isActive: json['isActive'] == true,
      createdBy: _parseString(json['createdBy']),
      updatedBy: _parseString(json['updatedBy']),
      createdAt:
          json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }
}

class PartnerConfig {
  final String partnerType;
  final List<String> regionIds;
  final List<dynamic> regions;
  final int basePoints;

  PartnerConfig({
    required this.partnerType,
    required this.regionIds,
    required this.regions,
    required this.basePoints,
  });

  factory PartnerConfig.fromJson(Map<String, dynamic> json) {
    return PartnerConfig(
      partnerType: _parseString(json['partnerType']),
      regionIds: _parseStringList(json['regionIds']),
      regions: json['regions'] is List ? json['regions'] as List<dynamic> : [],
      basePoints: _parseInt(json['basePoints']),
    );
  }
}

// SAFE PARSING HELPERS

String _parseString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) {
    return value['name']?.toString() ??
        value['title']?.toString() ??
        value['url']?.toString() ??
        value['en']?.toString() ??
        value.toString();
  }
  return value.toString();
}

List<String> _parseStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) {
      if (e is String) return e;
      if (e is Map) {
        return e['url']?.toString() ??
            e['imageUrl']?.toString() ??
            e['image']?.toString() ??
            e['path']?.toString() ??
            e['name']?.toString() ??
            e.toString();
      }
      return e.toString();
    }).toList();
  }
  if (value is String) return [value];
  return [];
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
