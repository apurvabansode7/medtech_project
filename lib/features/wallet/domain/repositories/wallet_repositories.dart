import 'package:medtech_project/features/wallet/data/models/wallet_transaction_model.dart';

abstract class WalletRepository {
  Future<WalletTransactionsResponseModel> getWalletTransactions({
    required int page,
    required int limit,
  });
}