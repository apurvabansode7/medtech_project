
import 'package:medtech_project/features/scan_history/data/models/scan_history_model.dart';

abstract class ScanHistoryState {}

class ScanHistoryInitial extends ScanHistoryState {}

class ScanHistoryLoading extends ScanHistoryState {}

class ScanHistorySuccess extends ScanHistoryState {
  final List<ScanHistoryModel> scans;

  final int currentPage;
  final int totalPages;
   final bool isLoadingMore;

  ScanHistorySuccess({
    required this.scans,
    required this.currentPage,
    required this.totalPages,
     this.isLoadingMore = false,
    
  });
}

class ScanHistoryFailure extends ScanHistoryState {
  final String message;

  ScanHistoryFailure({
    required this.message,
  });
}