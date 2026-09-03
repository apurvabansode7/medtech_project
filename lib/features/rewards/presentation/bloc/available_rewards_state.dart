import 'package:medtech_project/features/rewards/data/models/available_rewards_response.dart';

abstract class AvailableRewardsState {
  const AvailableRewardsState();
}

class AvailableRewardsInitial extends AvailableRewardsState {
  const AvailableRewardsInitial();
}

class AvailableRewardsLoading extends AvailableRewardsState {
  const AvailableRewardsLoading();
}

class AvailableRewardsLoaded extends AvailableRewardsState {
  final List<AvailableRewardItem> rewards;
  final int walletBalance;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int page;

  const AvailableRewardsLoaded({
    required this.rewards,
    required this.walletBalance,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.page = 1,
  });

  AvailableRewardsLoaded copyWith({
    List<AvailableRewardItem>? rewards,
    int? walletBalance,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? page,
  }) {
    return AvailableRewardsLoaded(
      rewards: rewards ?? this.rewards,
      walletBalance: walletBalance ?? this.walletBalance,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
    );
  }
}

class AvailableRewardsFailure extends AvailableRewardsState {
  final String message;

  const AvailableRewardsFailure({
    required this.message,
  });
}

