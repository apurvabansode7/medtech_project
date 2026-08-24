abstract class ScanHistoryEvent {}

class LoadScanHistory extends ScanHistoryEvent {
  final int page;
  final int limit;

  LoadScanHistory({
    this.page = 1,
    this.limit = 10,
  });
}