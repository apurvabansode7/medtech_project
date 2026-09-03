abstract class CampaignEarningsEvent {}

class CampaignEarningsRequested extends CampaignEarningsEvent {
  final String campaignId;
  final int page;
  final int pageSize;

  CampaignEarningsRequested({
    required this.campaignId,
    this.page = 1,
    this.pageSize = 20,
  });
}