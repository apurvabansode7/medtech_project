import 'package:medtech_project/features/home/data/models/campaign_response.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CampaignLoading extends HomeState {}

class CampaignSuccess extends HomeState {
  final CampaignResponse  response;

  CampaignSuccess({
    required this.response,
  });
}

class CampaignFailure extends HomeState {
  final String message;

  CampaignFailure({
    required this.message,
  });
}