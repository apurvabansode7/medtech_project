
import 'package:dio/dio.dart';
import 'package:medtech_project/features/profile/data/api/profile_api.dart';
import 'package:medtech_project/features/profile/data/models/profile_response_model.dart';
import 'package:medtech_project/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApi api;

  ProfileRepositoryImpl({
    required this.api,
  });

  @override
  Future<ProfileData> getProfile() async {
    try {
      final response = await api.getProfile();

      if (response.statusCode == 200) {
        final result = ProfileResponse.fromJson(
          response.data,
        );

        return result.data;
      }

      throw Exception(
        response.data?['message'] ??
            'Failed to load profile',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    }
  }
   @override
  Future<ProfileData> updateProfile({
    required Map<String, dynamic> data,
    
  }) async {
    try {
      final response = await api.updateProfile(
        data: data,
       
      );

      if (response.statusCode == 200) {
        final result = ProfileResponse.fromJson(
          response.data,
        );

        return result.data;
      }

      throw Exception(
        response.data?['message'] ??
            'Failed to update profile',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    }
  }
}