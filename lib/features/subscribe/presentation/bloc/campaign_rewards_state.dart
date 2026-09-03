

import 'package:medtech_project/features/subscribe/data/models/campaign_rewards_response.dart';

abstract class CampaignRewardsState {}

class CampaignRewardsInitial extends CampaignRewardsState {}

class CampaignRewardsLoading extends CampaignRewardsState {}

class CampaignRewardsSuccess extends CampaignRewardsState {
  final CampaignRewardsResponse response;

  CampaignRewardsSuccess({
    required this.response,
  });
}

class CampaignRewardsFailure extends CampaignRewardsState {
  final String message;

  CampaignRewardsFailure({
    required this.message,
  });
}

class ClaimCampaignRewardLoading extends CampaignRewardsState {
  final String rewardId;
  final CampaignRewardsResponse response;

  ClaimCampaignRewardLoading({
    required this.rewardId,
    required this.response,
  });
}

class ClaimCampaignRewardSuccess extends CampaignRewardsState {
  final String message;
  final String campaignId;
  final String rewardId;
  final CampaignRewardsResponse response;

  ClaimCampaignRewardSuccess({
    required this.message,
    required this.campaignId,
    required this.rewardId,
    required this.response,
  });
}

class ClaimCampaignRewardFailure extends CampaignRewardsState {
  final String message;
  final CampaignRewardsResponse response;

  ClaimCampaignRewardFailure({
    required this.message,
    required this.response,
  });
}