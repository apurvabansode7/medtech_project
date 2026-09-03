import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/home/presentation/bloc/enroll_campaign_event.dart';
import 'package:medtech_project/features/home/presentation/bloc/enroll_campaign_state.dart';

import '../../domain/repositories/campaign_repository.dart';


class CampaignEnrollBloc
    extends Bloc<CampaignEnrollEvent, CampaignEnrollState> {
  final CampaignRepository repository;

  CampaignEnrollBloc({
    required this.repository,
  }) : super(CampaignEnrollInitial()) {
    on<EnrollCampaignRequested>(_onEnrollCampaignRequested);
  }

  Future<void> _onEnrollCampaignRequested(
    EnrollCampaignRequested event,
    Emitter<CampaignEnrollState> emit,
  ) async {
    emit(
      CampaignEnrollLoading(
        campaignId: event.campaignId,
      ),
    );

    try {
      await repository.enrollCampaign(
        campaignId: event.campaignId,
        partnerId: event.partnerId,
        partnerType: event.partnerType,
        regionId: event.regionId,
      );

      emit(
        CampaignEnrollSuccess(
          message: 'Campaign subscribed successfully',
           campaignId: event.campaignId,
        ),
      );
    } catch (e) {
      emit(
        CampaignEnrollFailure(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }
}