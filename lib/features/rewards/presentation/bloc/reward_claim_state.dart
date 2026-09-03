abstract class RewardClaimState {
  const RewardClaimState();
}

class RewardClaimInitial extends RewardClaimState {
  const RewardClaimInitial();
}

class RewardClaimLoading extends RewardClaimState {
  const RewardClaimLoading();
}

class RewardClaimSuccess extends RewardClaimState {
  final String message;

  const RewardClaimSuccess({required this.message});
}

class RewardClaimFailure extends RewardClaimState {
  final String message;

  const RewardClaimFailure({required this.message});
}

