class RewardClaimResponse {
  final bool success;
  final List<RewardClaimItem> data;

  RewardClaimResponse({
    required this.success,
    required this.data,
  });

  factory RewardClaimResponse.fromJson(Map<String, dynamic> json) {
    List<RewardClaimItem> itemsList = [];

    final rawData = json['data'];
    if (rawData is List) {
      itemsList = rawData
          .whereType<Map<String, dynamic>>()
          .map((item) => RewardClaimItem.fromJson(item))
          .toList();
    } else if (rawData is Map<String, dynamic>) {
      final items = rawData['items'] ?? rawData['claims'] ?? rawData['rewards'];
      if (items is List) {
        itemsList = items
            .whereType<Map<String, dynamic>>()
            .map((item) => RewardClaimItem.fromJson(item))
            .toList();
      }
    }

    return RewardClaimResponse(
      success: json['success'] ?? false,
      data: itemsList,
    );
  }
}

class RewardClaimItem {
  final String id;
  final String rewardProductId;
  final RewardSnapshot? rewardSnapshot;
  final String partnerId;
  final PartnerSnapshot? partnerSnapshot;
  final int pointsRequired;
  final String note;
  final String status;
  final String deliveryStatus;
  final String? reviewedAt;
  final String? reviewedBy;
  final String? reviewNote;
  final String? walletTransactionId;
  final String? refundTransactionId;
  final String? createdAt;
  final String? updatedAt;

  RewardClaimItem({
    required this.id,
    required this.rewardProductId,
    this.rewardSnapshot,
    required this.partnerId,
    this.partnerSnapshot,
    required this.pointsRequired,
    required this.note,
    required this.status,
    required this.deliveryStatus,
    this.reviewedAt,
    this.reviewedBy,
    this.reviewNote,
    this.walletTransactionId,
    this.refundTransactionId,
    this.createdAt,
    this.updatedAt,
  });

  factory RewardClaimItem.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? rewardSnapJson;
    if (json['rewardSnapshot'] is Map<String, dynamic>) {
      rewardSnapJson = json['rewardSnapshot'] as Map<String, dynamic>;
    }

    Map<String, dynamic>? partnerSnapJson;
    if (json['partnerSnapshot'] is Map<String, dynamic>) {
      partnerSnapJson = json['partnerSnapshot'] as Map<String, dynamic>;
    }

    return RewardClaimItem(
      id: _parseString(json['id']),
      rewardProductId: _parseString(json['rewardProductId']),
      rewardSnapshot: rewardSnapJson != null
          ? RewardSnapshot.fromJson(rewardSnapJson)
          : null,
      partnerId: _parseString(json['partnerId']),
      partnerSnapshot: partnerSnapJson != null
          ? PartnerSnapshot.fromJson(partnerSnapJson)
          : null,
      pointsRequired: _parseInt(json['pointsRequired']),
      note: _parseString(json['note']),
      status: _parseString(json['status']),
      deliveryStatus: _parseString(json['deliveryStatus']),
      reviewedAt: _parseNullableString(json['reviewedAt']),
      reviewedBy: _parseNullableString(json['reviewedBy']),
      reviewNote: _parseNullableString(json['reviewNote']),
      walletTransactionId: _parseNullableString(json['walletTransactionId']),
      refundTransactionId: _parseNullableString(json['refundTransactionId']),
      createdAt: _parseNullableString(json['createdAt']),
      updatedAt: _parseNullableString(json['updatedAt']),
    );
  }
}

class RewardSnapshot {
  final String rewardProductId;
  final String name;
  final String categoryId;
  final String brand;
  final int pointsRequired;
  final String description;
  final List<String> images;

  RewardSnapshot({
    required this.rewardProductId,
    required this.name,
    required this.categoryId,
    required this.brand,
    required this.pointsRequired,
    required this.description,
    required this.images,
  });

  factory RewardSnapshot.fromJson(Map<String, dynamic> json) {
    return RewardSnapshot(
      rewardProductId: _parseString(json['rewardProductId']),
      name: _parseString(json['name']),
      categoryId: _parseString(json['categoryId']),
      brand: _parseString(json['brand']),
      pointsRequired: _parseInt(json['pointsRequired']),
      description: _parseString(json['description']),
      images: _parseStringList(json['images']),
    );
  }
}

class PartnerSnapshot {
  final String userId;
  final String name;
  final String businessName;
  final String role;
  final String mobile;

  PartnerSnapshot({
    required this.userId,
    required this.name,
    required this.businessName,
    required this.role,
    required this.mobile,
  });

  factory PartnerSnapshot.fromJson(Map<String, dynamic> json) {
    return PartnerSnapshot(
      userId: _parseString(json['userId']),
      name: _parseString(json['name']),
      businessName: _parseString(json['businessName']),
      role: _parseString(json['role']),
      mobile: _parseString(json['mobile']),
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
        value.toString();
  }
  return value.toString();
}

String? _parseNullableString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.isEmpty ? null : value;
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

