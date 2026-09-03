import 'package:medtech_project/features/home/data/models/partner_campaign_response.dart';

abstract class CampaignSubscribedState {}

class CampaignSubscribedInitial extends CampaignSubscribedState {}

class CampaignSubscribedLoading extends CampaignSubscribedState {}

class CampaignSubscribedSuccess extends CampaignSubscribedState {
  final PartnerCampaignResponse response;
  final bool isLoadingMore;

  CampaignSubscribedSuccess({
    required this.response,
    this.isLoadingMore = false,
  });
}

class CampaignSubscribedFailure extends CampaignSubscribedState {
  final String message;

  CampaignSubscribedFailure(this.message);
}