
import 'package:medtech_project/features/subscribe/data/models/campaign_earning_response.dart';

abstract class CampaignEarningsState {}

class CampaignEarningsInitial extends CampaignEarningsState {}

class CampaignEarningsLoading extends CampaignEarningsState {}

class CampaignEarningsSuccess extends CampaignEarningsState {
  final CampaignEarningsResponse response;
    final bool isLoadingMore;

  CampaignEarningsSuccess({
    required this.response,
  this.isLoadingMore = false,
  });
}

class CampaignEarningsFailure extends CampaignEarningsState {
  final String message;

  CampaignEarningsFailure({
    required this.message,
  });
}