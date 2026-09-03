import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:medtech_project/features/rewards/data/api/reward_api.dart';
import 'package:medtech_project/features/rewards/data/models/available_rewards_response.dart';
import 'package:medtech_project/features/rewards/data/models/reward_claim_response.dart';
import 'package:medtech_project/features/rewards/domain/repositories/reward_repository.dart';

class RewardRepositoryImpl implements RewardRepository {
  final RewardApi rewardApi;

  RewardRepositoryImpl({required this.rewardApi});

  @override
  Future<RewardClaimResponse> getMyRewardClaims({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await rewardApi.getMyRewardClaims(
        page: page,
        pageSize: pageSize,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return RewardClaimResponse.fromJson(data);
        } else if (data is List) {
          return RewardClaimResponse.fromJson({'success': true, 'data': data});
        }
      }

      throw Exception(
        response.data?['message'] ?? 'Failed to load reward claims',
      );
    } on DioException catch (e) {
      debugPrint('Get My Reward Claims Error: ${e.response?.data}');
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Something went wrong while fetching reward claims',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> claimReward({
    required String rewardId,
    String? note,
  }) async {
    try {
      final response = await rewardApi.claimReward(
        rewardId: rewardId,
        note: note,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return data;
        }
        return {'success': true, 'message': 'Reward claimed successfully'};
      }

      throw Exception(
        response.data?['message'] ?? 'Failed to claim reward',
      );
    } on DioException catch (e) {
      debugPrint('Claim Reward Error: ${e.response?.data}');
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Something went wrong while claiming reward',
      );
    }
  }

  @override
  Future<AvailableRewardsResponse> getAvailableRewards({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await rewardApi.getAvailableRewards(
        page: page,
        pageSize: pageSize,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return AvailableRewardsResponse.fromJson(data);
        }
      }

      throw Exception(
        response.data?['message'] ?? 'Failed to load available rewards',
      );
    } on DioException catch (e) {
      debugPrint('Get Available Rewards Error: ${e.response?.data}');
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Something went wrong while fetching available rewards',
      );
    }
  }
}

