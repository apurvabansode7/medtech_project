abstract class RewardClaimEvent {
  const RewardClaimEvent();
}

class SubmitRewardClaimEvent extends RewardClaimEvent {
  final String rewardId;
  final String? note;

  const SubmitRewardClaimEvent({
    required this.rewardId,
    this.note,
  });
}

