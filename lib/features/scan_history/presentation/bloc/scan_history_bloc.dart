import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/scan_history/domain/repositories/scan_history_repository.dart';

import 'scan_history_event.dart';
import 'scan_history_state.dart';

class ScanHistoryBloc extends Bloc<ScanHistoryEvent, ScanHistoryState> {
  final ScanHistoryRepository repository;

  ScanHistoryBloc({required this.repository}) : super(ScanHistoryInitial()) {
    on<LoadScanHistory>(_onLoadScanHistory);
  }

  Future<void> _onLoadScanHistory(
    LoadScanHistory event,
    Emitter<ScanHistoryState> emit,
  ) async {
    final bool isFirstPage = event.page == 1;

    if (isFirstPage) {
      emit(ScanHistoryLoading());
    }

    ScanHistorySuccess? previousState;

    if (!isFirstPage) {
      final currentState = state;

      if (currentState is! ScanHistorySuccess) {
        return;
      }

      previousState = currentState;

      emit(
        ScanHistorySuccess(
          scans: currentState.scans,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          isLoadingMore: true,
        ),
      );
    }

    try {
      final result = await repository.getScanHistory(
        page: event.page,
        limit: event.limit,
      );
      

      if (isFirstPage) {
        emit(
          ScanHistorySuccess(
            scans: result.scans,
            currentPage: result.currentPage,
            totalPages: result.totalPages,
            isLoadingMore: false,
          ),
        );

        return;
      }

      emit(
        ScanHistorySuccess(
          scans: [...previousState!.scans, ...result.scans],
          currentPage: result.currentPage,
          totalPages: result.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      if (!isFirstPage && previousState != null) {
        emit(
          ScanHistorySuccess(
            scans: previousState.scans,
            currentPage: previousState.currentPage,
            totalPages: previousState.totalPages,
            isLoadingMore: false,
          ),
        );

        return;
      }

      emit(
        ScanHistoryFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
