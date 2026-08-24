import 'package:dio/dio.dart';
import 'package:medtech_project/features/wallet/data/api/wallet_api.dart';
import 'package:medtech_project/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:medtech_project/features/wallet/domain/repositories/wallet_repositories.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletApi walletApi;

  WalletRepositoryImpl({
    required this.walletApi,
  });

  @override
  Future<WalletTransactionsResponseModel> getWalletTransactions({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await walletApi.getWalletTransactions(
        page: page,
        limit: limit,
      );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(
          response.data['data'],
        );

        return WalletTransactionsResponseModel.fromJson(data);
      }

      throw Exception(
        response.data?['message'] ??
            'Failed to fetch wallet transactions',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    } catch (e) {
      rethrow;
    }
  }
}