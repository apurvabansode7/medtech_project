import 'package:medtech_project/features/home/data/models/campaign_response.dart';
import 'package:medtech_project/features/home/data/models/partner_campaign_response.dart';
import 'package:medtech_project/features/subscribe/data/models/campaign_earning_response.dart';
import 'package:medtech_project/features/subscribe/data/models/campaign_rewards_response.dart';

abstract class CampaignRepository {
  Future<CampaignResponse> getCampaigns({
    required int page,
    required int pageSize,
  });

  // SUBSCRIPTIONS
  Future<PartnerCampaignResponse> getSubscribedCampaigns({
    required int page,
    required int pageSize,
  });

  Future<void> enrollCampaign({
    required String campaignId,
    required String partnerId,
    required String partnerType,
    required String regionId,
  });

  Future<CampaignEarningsResponse> getCampaignEarnings({
    required String campaignId,
    required int page,
    required int pageSize,
  });

  Future<CampaignRewardsResponse> getCampaignRewards({
    required String campaignId,
  });

  Future<void> claimCampaignReward({
    required String campaignId,
    required String rewardId,
  });
}
