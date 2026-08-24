import 'package:medtech_project/features/wallet/data/models/wallet_transaction_model.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletSuccess extends WalletState {
  final List<WalletTransactionModel> transactions;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool isLoadingMore;

  WalletSuccess({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.isLoadingMore = false,
  });
}

class WalletFailure extends WalletState {
  final String message;

  WalletFailure({
    required this.message,
  });
}