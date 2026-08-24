class InterestedProductResponse {
  final bool success;
  final InterestedProductData data;

  InterestedProductResponse({
    required this.success,
    required this.data,
  });

  factory InterestedProductResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return InterestedProductResponse(
      success: json['success'] ?? false,
      data: InterestedProductData.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}

class InterestedProductData {
  final List<InterestedProduct> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  InterestedProductData({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  factory InterestedProductData.fromJson(
    Map<String, dynamic> json,
  ) {
    return InterestedProductData(
      items: (json['items'] as List? ?? [])
          .map(
            (item) => InterestedProduct.fromJson(
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

class InterestedProduct {
  final String id;
  final String showcaseProductId;
  final ProductSnapshot productSnapshot;
  final String partnerId;
  final PartnerSnapshot partnerSnapshot;
  final dynamic regionDetails;
  final int quantityRequested;
  final String note;
  final String status;
  final DateTime? followedUpAt;
  final String? followedUpBy;
  final dynamic followedUpByDetails;
  final String? followUpNote;
  final String? closeReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InterestedProduct({
    required this.id,
    required this.showcaseProductId,
    required this.productSnapshot,
    required this.partnerId,
    required this.partnerSnapshot,
    this.regionDetails,
    required this.quantityRequested,
    required this.note,
    required this.status,
    this.followedUpAt,
    this.followedUpBy,
    this.followedUpByDetails,
    this.followUpNote,
    this.closeReason,
    this.createdAt,
    this.updatedAt,
  });

  factory InterestedProduct.fromJson(
    Map<String, dynamic> json,
  ) {
    return InterestedProduct(
      id: json['id'] ?? '',
      showcaseProductId: json['showcaseProductId'] ?? '',
      productSnapshot: ProductSnapshot.fromJson(
        json['productSnapshot'] ?? {},
      ),
      partnerId: json['partnerId'] ?? '',
      partnerSnapshot: PartnerSnapshot.fromJson(
        json['partnerSnapshot'] ?? {},
      ),
      regionDetails: json['regionDetails'],
      quantityRequested: json['quantityRequested'] ?? 0,
      note: json['note'] ?? '',
      status: json['status'] ?? '',
      followedUpAt: _parseDate(json['followedUpAt']),
      followedUpBy: json['followedUpBy'],
      followedUpByDetails: json['followedUpByDetails'],
      followUpNote: json['followUpNote'],
      closeReason: json['closeReason'],
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value.toString());
  }
}

class ProductSnapshot {
  final String showcaseProductId;
  final String name;
  final String categoryId;

  ProductSnapshot({
    required this.showcaseProductId,
    required this.name,
    required this.categoryId,
  });

  factory ProductSnapshot.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductSnapshot(
      showcaseProductId: json['showcaseProductId'] ?? '',
      name: json['name'] ?? '',
      categoryId: json['categoryId'] ?? '',
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

  factory PartnerSnapshot.fromJson(
    Map<String, dynamic> json,
  ) {
    return PartnerSnapshot(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      businessName: json['businessName'] ?? '',
      role: json['role'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}