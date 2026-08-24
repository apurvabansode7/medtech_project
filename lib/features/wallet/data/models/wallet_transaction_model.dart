
class WalletTransactionsResponseModel {
  final List<WalletTransactionModel> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  WalletTransactionsResponseModel({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  factory WalletTransactionsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final List itemsJson = json['items'] ?? [];

    return WalletTransactionsResponseModel(
      items: itemsJson
          .map(
            (item) => WalletTransactionModel.fromJson(
              Map<String, dynamic>.from(item),
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

class WalletTransactionModel {
  final String id;
  final String type;
  final int points;
  final String reason;
  final int balanceBefore;
  final int balanceAfter;
  final String createdAt;

  WalletTransactionModel({
    required this.id,
    required this.type,
    required this.points,
    required this.reason,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WalletTransactionModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      points: json['points'] is num
          ? (json['points'] as num).toInt()
          : 0,
      reason: json['reason'] ?? '',
      balanceBefore: json['balanceBefore'] is num
          ? (json['balanceBefore'] as num).toInt()
          : 0,
      balanceAfter: json['balanceAfter'] is num
          ? (json['balanceAfter'] as num).toInt()
          : 0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}