abstract class CampaignEnrollEvent {}

class EnrollCampaignRequested extends CampaignEnrollEvent {
  final String campaignId;
  final String partnerId;
  final String partnerType;
  final String regionId;

  EnrollCampaignRequested({
    required this.campaignId,
    required this.partnerId,
    required this.partnerType,
    required this.regionId,
  });
}