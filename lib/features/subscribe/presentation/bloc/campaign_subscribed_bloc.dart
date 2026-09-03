import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';
import 'campaign_subscribed_event.dart';
import 'campaign_subscribed_state.dart';

class CampaignSubscribedBloc
    extends Bloc<CampaignSubscribedEvent, CampaignSubscribedState> {
  final CampaignRepository repository;

  CampaignSubscribedBloc({
    required this.repository,
  }) : super(CampaignSubscribedInitial()) {
    on<CampaignSubscribedRequested>(_onCampaignSubscribedRequested);
  }

  Future<void> _onCampaignSubscribedRequested(
    CampaignSubscribedRequested event,
    Emitter<CampaignSubscribedState> emit,
  ) async {
    final isLoadingMore = event.page > 1;

    if (!isLoadingMore) {
      emit(CampaignSubscribedLoading());
    }

    try {
      final response = await repository.getSubscribedCampaigns(
        page: event.page,
        pageSize: event.pageSize,
      );

      emit(
        CampaignSubscribedSuccess(
          response: response,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        CampaignSubscribedFailure(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}