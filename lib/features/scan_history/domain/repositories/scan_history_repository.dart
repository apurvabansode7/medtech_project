
import 'package:medtech_project/features/scan_history/data/models/scan_history_model.dart';

abstract class ScanHistoryRepository {
  Future <ScanHistoryResponse> getScanHistory({
    required int page,
    required int limit,
  });
}