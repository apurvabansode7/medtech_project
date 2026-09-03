abstract class CampaignSubscribedEvent {}

class CampaignSubscribedRequested extends CampaignSubscribedEvent {
  final int page;
  final int pageSize;

  CampaignSubscribedRequested({
    required this.page,
    required this.pageSize,
  });
}