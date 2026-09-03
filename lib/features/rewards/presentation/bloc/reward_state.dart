import 'package:medtech_project/features/rewards/data/models/reward_claim_response.dart';

abstract class RewardState {
  const RewardState();
}

class RewardInitial extends RewardState {
  const RewardInitial();
}

class RewardClaimsLoading extends RewardState {
  const RewardClaimsLoading();
}

class RewardClaimsSuccess extends RewardState {
  final List<RewardClaimItem> claims;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int page;

  const RewardClaimsSuccess({
    required this.claims,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.page = 1,
  });

  RewardClaimsSuccess copyWith({
    List<RewardClaimItem>? claims,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? page,
  }) {
    return RewardClaimsSuccess(
      claims: claims ?? this.claims,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
    );
  }
}

class RewardClaimsFailure extends RewardState {
  final String message;

  const RewardClaimsFailure({
    required this.message,
  });
}

class ClaimRewardLoading extends RewardState {
  const ClaimRewardLoading();
}

class ClaimRewardSuccess extends RewardState {
  final String message;

  const ClaimRewardSuccess({
    required this.message,
  });
}

class ClaimRewardFailure extends RewardState {
  final String message;

  const ClaimRewardFailure({
    required this.message,
  });
}
