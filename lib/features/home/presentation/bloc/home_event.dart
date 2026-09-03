abstract class HomeEvent {}

class CampaignRequested extends HomeEvent {
  final int page;
  final int pageSize;

  CampaignRequested({
    this.page = 1,
    this.pageSize = 10,
  });
}
