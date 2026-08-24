class ShowcaseProductResponse {
  final bool success;
  final ShowcaseProductData data;

  ShowcaseProductResponse({
    required this.success,
    required this.data,
  });

  factory ShowcaseProductResponse.fromJson(Map<String, dynamic> json) {
    return ShowcaseProductResponse(
      success: json['success'] ?? false,
      data: ShowcaseProductData.fromJson(json['data'] ?? {}),
    );
  }
}

class ShowcaseProductData {
  final List<ShowcaseProduct> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  ShowcaseProductData({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  factory ShowcaseProductData.fromJson(Map<String, dynamic> json) {
    return ShowcaseProductData(
      items: (json['items'] as List? ?? [])
          .map(
            (item) => ShowcaseProduct.fromJson(
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

class ShowcaseProduct {
  final String id;
  final String productCode;
  final String name;
  final String description;
  final String categoryId;
  final ProductCategory? category;
  final List<ProductImage> images;
  final num mrp;
  final num dealerPrice;
  final num chemistPrice;
  final bool isActive;
  final List<String> visibleTo;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShowcaseProduct({
    required this.id,
    required this.productCode,
    required this.name,
    required this.description,
    required this.categoryId,
    this.category,
    required this.images,
    required this.mrp,
    required this.dealerPrice,
    required this.chemistPrice,
    required this.isActive,
    required this.visibleTo,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ShowcaseProduct.fromJson(Map<String, dynamic> json) {
    return ShowcaseProduct(
      id: json['id'] ?? '',
      productCode: json['productCode'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
      images: (json['images'] as List? ?? [])
          .map(
            (item) => ProductImage.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      mrp: json['mrp'] ?? 0,
      dealerPrice: json['dealerPrice'] ?? 0,
      chemistPrice: json['chemistPrice'] ?? 0,
      isActive: json['isActive'] ?? false,
      visibleTo: List<String>.from(
        json['visibleTo'] ?? [],
      ),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class ProductCategory {
  final String id;
  final String code;
  final String name;

  ProductCategory({
    required this.id,
    required this.code,
    required this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ProductImage {
  final String url;
  final bool isPrimary;

  ProductImage({
    required this.url,
    required this.isPrimary,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json['url'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}