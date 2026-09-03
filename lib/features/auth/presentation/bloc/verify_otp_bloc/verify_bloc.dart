import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medtech_project/features/auth/domain/repositories/auth_repository.dart';

import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

class VerifyOtpBloc
    extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final AuthRepository authRepository;

  VerifyOtpBloc({
    required this.authRepository,
  }) : super(const VerifyOtpInitial()) {
    on<VerifyOtpSubmitted>(
      _onVerifyOtpSubmitted,
    );
       on<ResendOtpRequested>(
      _onResendOtpRequested,
    );
  }

  Future<void> _onVerifyOtpSubmitted(
    VerifyOtpSubmitted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoading());

    try {
      final result = await authRepository.verifyOtp(
        email: event.email,
        otp: event.otp,
        deviceId: event.deviceId,
        appVersion: event.appVersion,
        platform: event.platform,
      );

emit(
  VerifyOtpSuccess(
    accessToken: result['accessToken'],
    refreshToken: result['refreshToken'],
  ),
);
    } catch (e) {
      emit(
        VerifyOtpFailure(
          e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }
   Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const ResendOtpLoading());

    try {
      await authRepository.resendOtp(
        email: event.email,
        deviceId: event.deviceId,
        appVersion: event.appVersion,
      );

      emit(
        const ResendOtpSuccess(),
      );
    } catch (e) {
      emit(
        ResendOtpFailure(
          e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }
}