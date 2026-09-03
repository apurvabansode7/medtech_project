import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/home/domain/repositories/campaign_repository.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_earnings_event.dart.dart';
import 'package:medtech_project/features/subscribe/presentation/bloc/campaign_earnings_state.dart.dart';


class CampaignEarningsBloc
    extends Bloc<CampaignEarningsEvent, CampaignEarningsState> {
  final CampaignRepository repository;

  CampaignEarningsBloc({
    required this.repository,
  }) : super(CampaignEarningsInitial()) {
    on<CampaignEarningsRequested>(_onCampaignEarningsRequested);
  }

  Future<void> _onCampaignEarningsRequested(
    CampaignEarningsRequested event,
    Emitter<CampaignEarningsState> emit,
  ) async {
    emit(CampaignEarningsLoading());

    try {
      final response = await repository.getCampaignEarnings(
        campaignId: event.campaignId,
        page: event.page,
        pageSize: event.pageSize,
      );

      emit(
        CampaignEarningsSuccess(
          response: response,
        ),
      );
    } catch (e) {
      emit(
        CampaignEarningsFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}