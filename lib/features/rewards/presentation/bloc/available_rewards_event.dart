abstract class AvailableRewardsEvent {
  const AvailableRewardsEvent();
}

class LoadAvailableRewards extends AvailableRewardsEvent {
  final int page;
  final int limit;
  final bool isRefresh;

  const LoadAvailableRewards({
    this.page = 1,
    this.limit = 10,
    this.isRefresh = false,
  });
}

class LoadMoreAvailableRewards extends AvailableRewardsEvent {
  const LoadMoreAvailableRewards();
}

