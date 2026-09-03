abstract class CampaignRewardsEvent {}

class CampaignRewardsRequested extends CampaignRewardsEvent {
  final String campaignId;

  CampaignRewardsRequested({
    required this.campaignId,
  });
}

class ClaimCampaignRewardRequested extends CampaignRewardsEvent {
  final String campaignId;
  final String rewardId;

  ClaimCampaignRewardRequested({
    required this.campaignId,
    required this.rewardId,
  });
}

