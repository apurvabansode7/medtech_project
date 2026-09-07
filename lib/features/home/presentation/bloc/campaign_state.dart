import 'package:medtech_project/features/home/data/models/campaign_response.dart';

abstract class CampaignState {}

class CampaignInitial extends CampaignState {}

class CampaignLoading extends CampaignState {}

class CampaignSuccess extends CampaignState {
  final CampaignResponse  response;

  CampaignSuccess({
    required this.response,
  });
}

class CampaignFailure extends CampaignState {
  final String message;

  CampaignFailure({
    required this.message,
  });
}