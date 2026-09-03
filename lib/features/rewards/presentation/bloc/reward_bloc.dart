import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/rewards/domain/repositories/reward_repository.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/reward_event.dart';
import 'package:medtech_project/features/rewards/presentation/bloc/reward_state.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final RewardRepository repository;

  RewardBloc({required this.repository}) : super(const RewardInitial()) {
    on<RewardClaimsRequested>(_onRewardClaimsRequested);
    on<LoadMoreRewardClaims>(_onLoadMoreRewardClaims);
    on<SubmitRewardClaim>(_onSubmitRewardClaim);
  }

  Future<void> _onRewardClaimsRequested(
    RewardClaimsRequested event,
    Emitter<RewardState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(const RewardClaimsLoading());
    }

    try {
      final response = await repository.getMyRewardClaims(
        page: event.page,
        pageSize: event.limit,
      );

      final newItems = response.data;
      final hasReachedMax = newItems.length < event.limit;

      emit(
        RewardClaimsSuccess(
          claims: newItems,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
          page: event.page,
        ),
      );
    } catch (e) {
      emit(
        RewardClaimsFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoadMoreRewardClaims(
    LoadMoreRewardClaims event,
    Emitter<RewardState> emit,
  ) async {
    final currentState = state;
    if (currentState is! RewardClaimsSuccess) return;
    if (currentState.hasReachedMax || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.page + 1;
      final response = await repository.getMyRewardClaims(
        page: nextPage,
        pageSize: 10,
      );

      final newItems = response.data;
      if (newItems.isEmpty) {
        emit(
          currentState.copyWith(
            hasReachedMax: true,
            isLoadingMore: false,
          ),
        );
      } else {
        emit(
          RewardClaimsSuccess(
            claims: [...currentState.claims, ...newItems],
            hasReachedMax: newItems.length < 10,
            isLoadingMore: false,
            page: nextPage,
          ),
        );
      }
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSubmitRewardClaim(
    SubmitRewardClaim event,
    Emitter<RewardState> emit,
  ) async {
    emit(const ClaimRewardLoading());

    try {
      final res = await repository.claimReward(
        rewardId: event.rewardId,
        note: event.note,
      );

      final msg = res['message']?.toString() ?? 'Reward claimed successfully';
      emit(ClaimRewardSuccess(message: msg));
    } catch (e) {
      emit(
        ClaimRewardFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
