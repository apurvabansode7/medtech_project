import 'package:dio/dio.dart';
import 'package:medtech_project/core/services/api_services.dart';

class CampaignApi {
  final ApiService apiService;

  CampaignApi({required this.apiService});

  // HOME
  Future<Response> getCampaigns({
    required int page,
    required int pageSize,
  }) async {
    return await apiService.get(
      '/api/v1/campaigns',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
  }

  // SUBSCRIPTIONS
  Future<Response> getSubscribedCampaigns({
    required int page,
    required int pageSize,
  }) async {
    return await apiService.get(
      '/api/v1/partners/campaigns',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
  }

  Future<Response> enrollCampaign({required String campaignId}) async {
    return await apiService.post('/api/v1/campaigns/$campaignId/enroll');
  }

  Future<Response> getCampaignEarnings({
    required String campaignId,
    required int page,
    required int pageSize,
  }) async {
    return await apiService.get(
      '/api/v1/partners/campaigns/$campaignId/earnings',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
  }

  Future<Response> getCampaignRewards({
    required String campaignId,
    required int page,
    required int pageSize,
  }) async {
    return await apiService.get(
      '/api/v1/partners/campaigns/$campaignId/rewards',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
  }

  Future<Response> claimCampaignReward({
    required String campaignId,
    required String rewardId,
  }) async {
    return await apiService.post(
      '/api/v1/rewards/campaigns/$campaignId/rewards/$rewardId/claim',
    );
  }
}
