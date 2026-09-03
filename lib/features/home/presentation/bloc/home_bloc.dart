import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CampaignRepository repository;

  HomeBloc({
    required this.repository,
  }) : super(HomeInitial()) {
    on<CampaignRequested>(_onCampaignRequested);
   
  }

  Future<void> _onCampaignRequested(
    CampaignRequested event,
    Emitter<HomeState> emit,
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