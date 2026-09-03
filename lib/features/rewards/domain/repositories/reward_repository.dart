import 'package:medtech_project/features/rewards/data/models/available_rewards_response.dart';
import 'package:medtech_project/features/rewards/data/models/reward_claim_response.dart';

abstract class RewardRepository {
  /// Fetch all reward claims submitted by the logged-in partner.
  Future<RewardClaimResponse> getMyRewardClaims({
    int page = 1,
    int pageSize = 10,
  });

  /// Submit a claim for a reward product by ID (/rewards/{id}/claim).
  Future<Map<String, dynamic>> claimReward({
    required String rewardId,
    String? note,
  });

  /// Fetch all available rewards for the partner (/rewards/available).
  Future<AvailableRewardsResponse> getAvailableRewards({
    int page = 1,
    int pageSize = 10,
  });
}

