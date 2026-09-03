abstract class RewardEvent {
  const RewardEvent();
}

class RewardClaimsRequested extends RewardEvent {
  final int page;
  final int limit;
  final bool isRefresh;

  const RewardClaimsRequested({
    this.page = 1,
    this.limit = 10,
    this.isRefresh = false,
  });
}

class LoadMoreRewardClaims extends RewardEvent {
  const LoadMoreRewardClaims();
}

class SubmitRewardClaim extends RewardEvent {
  final String rewardId;
  final String? note;

  const SubmitRewardClaim({
    required this.rewardId,
    this.note,
  });
}
