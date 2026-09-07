import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';

import 'campaign_event.dart';
import 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final CampaignRepository repository;

  CampaignBloc({
    required this.repository,
  }) : super(CampaignInitial()) {
    on<CampaignRequested>(_onCampaignRequested);
   
  }

  Future<void> _onCampaignRequested(
    CampaignRequested event,
    Emitter<CampaignState> emit,
  ) async {
    emit(CampaignLoading());

    try {
      final response = await repository.getCampaigns(
        page: event.page,
        pageSize: event.pageSize,
      );

      emit(
        CampaignSuccess(
          response: response,
        ),
      );
    } catch (e) {
      emit(
        CampaignFailure(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }


}