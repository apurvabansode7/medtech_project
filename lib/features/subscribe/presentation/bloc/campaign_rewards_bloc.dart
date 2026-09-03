import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';
import 'package:medtech_project/features/subscribe/data/models/campaign_rewards_response.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_rewards_event.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_rewards_state.dart';

class CampaignRewardsBloc extends Bloc<CampaignRewardsEvent, CampaignRewardsState> {
  final CampaignRepository repository;

  CampaignRewardsBloc({
    required this.repository,
  }) : super(CampaignRewardsInitial()) {
    on<CampaignRewardsRequested>(_onCampaignRewardsRequested);
    on<ClaimCampaignRewardRequested>(_onClaimCampaignRewardRequested);
  }

  Future<void> _onCampaignRewardsRequested(
    CampaignRewardsRequested event,
    Emitter<CampaignRewardsState> emit,
  ) async {
    emit(CampaignRewardsLoading());

    try {
      final response = await repository.getCampaignRewards(
        campaignId: event.campaignId,
      );

      emit(
        CampaignRewardsSuccess(
          response: response,
        ),
      );
    } catch (e) {
      emit(
        CampaignRewardsFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

 Future<void> _onClaimCampaignRewardRequested(
  ClaimCampaignRewardRequested event,
  Emitter<CampaignRewardsState> emit,
) async {
  final currentState = state;

  CampaignRewardsResponse? currentResponse;

  if (currentState is CampaignRewardsSuccess) {
    currentResponse = currentState.response;
  } else if (currentState is ClaimCampaignRewardLoading) {
    currentResponse = currentState.response;
  } else if (currentState is ClaimCampaignRewardSuccess) {
    currentResponse = currentState.response;
  } else if (currentState is ClaimCampaignRewardFailure) {
    currentResponse = currentState.response;
  }

  if (currentResponse == null) {
    return;
  }

  emit(
    ClaimCampaignRewardLoading(
      rewardId: event.rewardId,
      response: currentResponse,
    ),
  );

  try {
    await repository.claimCampaignReward(
      campaignId: event.campaignId,
      rewardId: event.rewardId,
    );

    emit(
      ClaimCampaignRewardSuccess(
        message: 'Reward claimed successfully!',
        campaignId: event.campaignId,
        rewardId: event.rewardId,
        response: currentResponse,
      ),
    );
  } catch (e) {
    emit(
      ClaimCampaignRewardFailure(
        message: e.toString().replaceFirst('Exception: ', ''),
        response: currentResponse,
      ),
    );
  }
}
}

