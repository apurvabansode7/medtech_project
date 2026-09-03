import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/rewards/domain/repositories/reward_repository.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/available_rewards_event.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/available_rewards_state.dart';

class AvailableRewardsBloc
    extends Bloc<AvailableRewardsEvent, AvailableRewardsState> {
  final RewardRepository repository;

  AvailableRewardsBloc({required this.repository})
      : super(const AvailableRewardsInitial()) {
    on<LoadAvailableRewards>(_onLoadAvailableRewards);
    on<LoadMoreAvailableRewards>(_onLoadMoreAvailableRewards);
  }

  Future<void> _onLoadAvailableRewards(
    LoadAvailableRewards event,
    Emitter<AvailableRewardsState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(const AvailableRewardsLoading());
    }

    try {
      final response = await repository.getAvailableRewards(
        page: event.page,
        pageSize: event.limit,
      );

      final items = response.data.items;
      final walletBalance = response.data.walletBalance;
      final hasReachedMax = response.data.currentPage >= response.data.totalPages ||
          items.length < event.limit;

      emit(
        AvailableRewardsLoaded(
          rewards: items,
          walletBalance: walletBalance,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
          page: response.data.currentPage,
        ),
      );
    } catch (e) {
      emit(
        AvailableRewardsFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoadMoreAvailableRewards(
    LoadMoreAvailableRewards event,
    Emitter<AvailableRewardsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AvailableRewardsLoaded) return;
    if (currentState.hasReachedMax || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.page + 1;
      final response = await repository.getAvailableRewards(
        page: nextPage,
        pageSize: 10,
      );

      final newItems = response.data.items;
      final newWalletBalance = response.data.walletBalance;
      final hasReachedMax = response.data.currentPage >= response.data.totalPages ||
          newItems.length < 10;

      if (newItems.isEmpty) {
        emit(
          currentState.copyWith(
            hasReachedMax: true,
            isLoadingMore: false,
          ),
        );
      } else {
        emit(
          AvailableRewardsLoaded(
            rewards: [...currentState.rewards, ...newItems],
            walletBalance: newWalletBalance,
            hasReachedMax: hasReachedMax,
            isLoadingMore: false,
            page: nextPage,
          ),
        );
      }
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}

