import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:medtech_project/features/wallet/domain/repositories/wallet_repositories.dart';

import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository repository;

  static const int pageSize = 10;

  WalletBloc({
    required this.repository,
  }) : super(WalletInitial()) {
    on<LoadWalletTransactions>(_onLoadWalletTransactions);
    on<RefreshWalletTransactions>(_onRefreshWalletTransactions);
    on<LoadMoreWalletTransactions>(_onLoadMoreWalletTransactions);
  }

  Future<void> _onLoadWalletTransactions(
    LoadWalletTransactions event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());

    try {
      final response = await repository.getWalletTransactions(
        page: event.page,
        limit: event.limit,
      );

      emit(
        WalletSuccess(
          transactions: response.items,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          totalItems: response.totalItems,
        ),
      );
    } catch (e) {
      emit(
        WalletFailure(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }

  Future<void> _onRefreshWalletTransactions(
    RefreshWalletTransactions event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final response = await repository.getWalletTransactions(
        page: 1,
        limit: pageSize,
      );

      emit(
        WalletSuccess(
          transactions: response.items,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          totalItems: response.totalItems,
        ),
      );
    } catch (e) {
      emit(
        WalletFailure(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }

  Future<void> _onLoadMoreWalletTransactions(
    LoadMoreWalletTransactions event,
    Emitter<WalletState> emit,
  ) async {
    final currentState = state;

    if (currentState is! WalletSuccess) {
      return;
    }

    if (currentState.isLoadingMore) {
      return;
    }

    if (currentState.currentPage >= currentState.totalPages) {
      return;
    }

    emit(
      WalletSuccess(
        transactions: currentState.transactions,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        totalItems: currentState.totalItems,
        isLoadingMore: true,
      ),
    );

    try {
      final nextPage = currentState.currentPage + 1;

      final response = await repository.getWalletTransactions(
        page: nextPage,
        limit: pageSize,
      );

      final List<WalletTransactionModel> updatedTransactions = [
        ...currentState.transactions,
        ...response.items,
      ];

      emit(
        WalletSuccess(
          transactions: updatedTransactions,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          totalItems: response.totalItems,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        WalletSuccess(
          transactions: currentState.transactions,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          totalItems: currentState.totalItems,
          isLoadingMore: false,
        ),
      );
    }
  }
}