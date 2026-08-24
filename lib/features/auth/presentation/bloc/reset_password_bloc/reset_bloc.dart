import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medtech_project/features/auth/domain/repositories/auth_repository.dart';

import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetBloc
    extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository authRepository;

  ResetBloc({
    required this.authRepository,
  }) : super(const ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(
      _onResetPasswordSubmitted,
    );
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(const ResetPasswordLoading());

    try {
      await authRepository.resetPassword(
        otpId: event.otpId,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      emit(
        const ResetPasswordSuccess(),
      );
    } catch (e) {
      emit(
        ResetPasswordFailure(
          e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }
}