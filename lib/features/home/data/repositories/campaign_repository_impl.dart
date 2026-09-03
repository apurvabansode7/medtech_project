import 'package:dio/dio.dart';
import 'package:medtech_project/features/home/data/api/campaign_api.dart';
import 'package:medtech_project/features/home/data/models/campaign_response.dart';
import 'package:medtech_project/features/home/data/models/partner_campaign_response.dart';
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';
import 'package:medtech_project/features/subscribe/data/models/campaign_earning_response.dart';
import 'package:medtech_project/features/subscribe/data/models/campaign_rewards_response.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  final CampaignApi api;

  CampaignRepositoryImpl({
    required this.api,
  });

 @override
Future<CampaignResponse> getCampaigns({
  required int page,
  required int pageSize,
}) async {
  try {
    final response = await api.getCampaigns(
      page: page,
      pageSize: pageSize,
    );

    if (response.statusCode == 200) {
      return CampaignResponse.fromJson(response.data);
    }

    throw Exception(
      response.data?['message'] ?? 'Failed to load campaigns',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ?? 'Something went wrong',
    );
  }
}

@override
Future<PartnerCampaignResponse> getSubscribedCampaigns({
  required int page,
  required int pageSize,
}) async {
  try {
    final response = await api.getSubscribedCampaigns(
      page: page,
      pageSize: pageSize,
    );

    if (response.statusCode == 200) {
      return PartnerCampaignResponse.fromJson(response.data);
    }

    throw Exception(
      response.data?['message'] ?? 'Failed to load subscribed campaigns',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ?? 'Something went wrong',
    );
  }
}


@override
Future<void> enrollCampaign({
  required String campaignId,
  required String partnerId,
  required String partnerType,
  required String regionId,
}) async {
  try {
    final response = await api.enrollCampaign(
      campaignId: campaignId,
      // partnerId: partnerId,
      // partnerType: partnerType,
      // regionId: regionId,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return;
    }

    throw Exception(
      response.data?['message'] ??
          'Failed to enroll in campaign',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
  }
}

@override
Future<CampaignEarningsResponse> getCampaignEarnings({
  required String campaignId,
  required int page,
  required int pageSize,
}) async {
  try {
    final response = await api.getCampaignEarnings(
      campaignId: campaignId,
      page: page,
      pageSize: pageSize,
    );

    if (response.statusCode == 200) {
      return CampaignEarningsResponse.fromJson(
        response.data,
      );
    }

    throw Exception(
      response.data?['message'] ??
          'Failed to load campaign earnings',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
  }
}

@override
Future<CampaignRewardsResponse> getCampaignRewards({
  required String campaignId,
}) async {
  try {
    final response = await api.getCampaignRewards(
      campaignId: campaignId,
      page: 1,
      pageSize: 10,
    );

    if (response.statusCode == 200) {
      return CampaignRewardsResponse.fromJson(
        response.data,
      );
    }

    throw Exception(
      response.data?['message'] ??
          'Failed to load campaign rewards',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ??
          'Something went wrong',
    );
  }
}

@override
Future<void> claimCampaignReward({
  required String campaignId,
  required String rewardId,
}) async {
  try {
    final response = await api.claimCampaignReward(
      campaignId: campaignId,
      rewardId: rewardId,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception(
      response.data?['message'] ?? 'Failed to claim reward',
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data?['message'] ?? 'Something went wrong',
    );
  }
}

}

