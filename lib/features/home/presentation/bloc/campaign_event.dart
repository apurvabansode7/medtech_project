abstract class CampaignEvent {}

class CampaignRequested extends CampaignEvent {
  final int page;
  final int pageSize;

  CampaignRequested({
    this.page = 1,
    this.pageSize = 10,
  });
}
