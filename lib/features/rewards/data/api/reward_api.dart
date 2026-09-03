import 'package:dio/dio.dart';
import 'package:medtech_project/core/services/api_services.dart';

class RewardApi {
  final ApiService apiService;

  RewardApi({required this.apiService});

  /// GET /api/v1/rewards/claims/me
  /// Retrieve all reward claims submitted by the logged-in partner.
  Future<Response> getMyRewardClaims(
    {
       required int page,
    required int pageSize,
    }
  ) async {

    return await apiService.get('/api/v1/rewards/claims/me', queryParameters: {
      'page': page,
      'pageSize': pageSize,
      // Add any query parameters if needed
    });
  }

  /// POST /api/v1/rewards/{id}/claim
  /// Submit a claim request for a reward product by ID.
  Future<Response> claimReward({
    required String rewardId,
    String? note,
  }) async {
    return await apiService.post(
      '/api/v1/rewards/$rewardId/claim',
      data: {
        if (note != null && note.isNotEmpty) 'note': note,
      },
    );
  }

  /// GET /api/v1/rewards/available
  /// Get all available rewards for the partner.
  Future<Response> getAvailableRewards({
    required int page,
    required int pageSize,
  }) async {
    return await apiService.get(
      '/api/v1/rewards/available',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
  }
}

