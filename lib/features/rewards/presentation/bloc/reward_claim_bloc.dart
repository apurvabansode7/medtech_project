import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/rewards/domain/repositories/reward_repository.dart';

import 'reward_claim_event.dart';
import 'reward_claim_state.dart';

class RewardClaimBloc extends Bloc<RewardClaimEvent, RewardClaimState> {
  final RewardRepository repository;

  RewardClaimBloc({required this.repository}) : super(const RewardClaimInitial()) {
    on<SubmitRewardClaimEvent>(_onSubmitRewardClaimEvent);
  }

  Future<void> _onSubmitRewardClaimEvent(
    SubmitRewardClaimEvent event,
    Emitter<RewardClaimState> emit,
  ) async {
    emit(const RewardClaimLoading());

    try {
      final res = await repository.claimReward(
        rewardId: event.rewardId,
        note: event.note,
      );

      final msg = res['message']?.toString() ?? 'Reward claimed successfully';
      emit(RewardClaimSuccess(message: msg));
    } catch (e) {
      emit(
        RewardClaimFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}

