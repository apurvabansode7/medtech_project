class AvailableRewardsResponse {
  final bool success;
  final AvailableRewardsData data;

  AvailableRewardsResponse({
    required this.success,
    required this.data,
  });

  factory AvailableRewardsResponse.fromJson(Map<String, dynamic> json) {
    return AvailableRewardsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? AvailableRewardsData.fromJson(json['data'] as Map<String, dynamic>)
          : AvailableRewardsData.empty(),
    );
  }
}

class AvailableRewardsData {
  final List<AvailableRewardItem> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final int walletBalance;

  AvailableRewardsData({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.walletBalance,
  });

  factory AvailableRewardsData.empty() {
    return AvailableRewardsData(
      items: [],
      totalItems: 0,
      totalPages: 1,
      currentPage: 1,
      pageSize: 10,
      walletBalance: 0,
    );
  }

  factory AvailableRewardsData.fromJson(Map<String, dynamic> json) {
    List<AvailableRewardItem> itemsList = [];
    if (json['items'] is List) {
      itemsList = (json['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => AvailableRewardItem.fromJson(e))
          .toList();
    }

    return AvailableRewardsData(
      items: itemsList,
      totalItems: _parseInt(json['totalItems']),
      totalPages: _parseInt(json['totalPages']),
      currentPage: _parseInt(json['currentPage']),
      pageSize: _parseInt(json['pageSize']),
      walletBalance: _parseInt(json['walletBalance']),
    );
  }
}

class AvailableRewardItem {
  final String id;
  final String rewardProductId;
  final String name;
  final String description;
  final RewardCategory? category;
  final String brand;
  final List<RewardImage> images;
  final int pointsRequired;
  final int availableQuantity;
  final bool isClaimable;

  AvailableRewardItem({
    required this.id,
    required this.rewardProductId,
    required this.name,
    required this.description,
    this.category,
    required this.brand,
    required this.images,
    required this.pointsRequired,
    required this.availableQuantity,
    required this.isClaimable,
  });

  factory AvailableRewardItem.fromJson(Map<String, dynamic> json) {
    List<RewardImage> imgList = [];
    if (json['images'] is List) {
      imgList = (json['images'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => RewardImage.fromJson(e))
          .toList();
    }

    return AvailableRewardItem(
      id: _parseString(json['id']),
      rewardProductId: _parseString(json['rewardProductId']),
      name: _parseString(json['name']),
      description: _parseString(json['description']),
      category: json['category'] is Map<String, dynamic>
          ? RewardCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      brand: _parseString(json['brand']),
      images: imgList,
      pointsRequired: _parseInt(json['pointsRequired']),
      availableQuantity: _parseInt(json['availableQuantity']),
      isClaimable: _parseBool(json['isClaimable']),
    );
  }

  /// Helper getter for primary or first image URL
  String get primaryImageUrl {
    if (images.isEmpty) return '';
    final primary = images.firstWhere(
      (img) => img.isPrimary,
      orElse: () => images.first,
    );
    return primary.signedViewUrl.isNotEmpty
        ? primary.signedViewUrl
        : primary.url;
  }
}

class RewardCategory {
  final String id;
  final String code;
  final String name;

  RewardCategory({
    required this.id,
    required this.code,
    required this.name,
  });

  factory RewardCategory.fromJson(Map<String, dynamic> json) {
    return RewardCategory(
      id: _parseString(json['id']),
      code: _parseString(json['code']),
      name: _parseString(json['name']),
    );
  }
}

class RewardImage {
  final String url;
  final bool isPrimary;
  final String path;
  final String signedViewUrl;
  final String objectUrl;

  RewardImage({
    required this.url,
    required this.isPrimary,
    required this.path,
    required this.signedViewUrl,
    required this.objectUrl,
  });

  factory RewardImage.fromJson(Map<String, dynamic> json) {
    return RewardImage(
      url: _parseString(json['url']),
      isPrimary: _parseBool(json['isPrimary']),
      path: _parseString(json['path']),
      signedViewUrl: _parseString(json['signedViewUrl']),
      objectUrl: _parseString(json['objectUrl']),
    );
  }
}

// SAFE PARSING HELPERS
String _parseString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  return false;
}

