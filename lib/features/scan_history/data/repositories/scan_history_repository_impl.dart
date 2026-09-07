import 'package:dio/dio.dart';

import '../../domain/repositories/scan_history_repository.dart';
import '../api/scan_history_api.dart';
import '../models/scan_history_model.dart';

class ScanHistoryRepositoryImpl
    implements ScanHistoryRepository {
    final ScanHistoryApi scanHistoryApi;

  ScanHistoryRepositoryImpl({
    required this.scanHistoryApi,
  });

  @override
  Future<ScanHistoryResponse> getScanHistory({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await scanHistoryApi.getScanHistory(
        page: page,
        limit: limit,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        final List items = data['items'] ?? [];

        final scans = items
            .map(
              (item) => ScanHistoryModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();

        return ScanHistoryResponse(
          scans: scans,
          currentPage: data['page'] ?? page,
          totalPages: data['totalPages'] ?? 1,
        );
      }

      throw Exception(
        response.data?['message'] ??
            'Failed to fetch scan history',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Something went wrong',
      );
    }
  }
}