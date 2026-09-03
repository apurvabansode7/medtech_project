abstract class CampaignEnrollState {}

class CampaignEnrollInitial extends CampaignEnrollState {}

class CampaignEnrollLoading extends CampaignEnrollState {
  final String campaignId;

  CampaignEnrollLoading({
    required this.campaignId,
  });
}

class CampaignEnrollSuccess extends CampaignEnrollState {
  final String message;
    final String campaignId;

  CampaignEnrollSuccess({
    required this.message,
      required this.campaignId,
  });
}

class CampaignEnrollFailure extends CampaignEnrollState {
  final String message;

  CampaignEnrollFailure({
    required this.message,
  });
}