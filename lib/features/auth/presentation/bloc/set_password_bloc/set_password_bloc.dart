import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/auth/domain/repositories/auth_repository.dart';

import 'set_password_event.dart';
import 'set_password_state.dart';

class SetPasswordBloc
    extends Bloc<SetPasswordEvent, SetPasswordState> {
  final AuthRepository authRepository;

  SetPasswordBloc({
    required this.authRepository,
  }) : super(const SetPasswordInitial()) {
    on<SetPasswordSubmitted>(_onSetPasswordSubmitted);
  }

  Future<void> _onSetPasswordSubmitted(
    SetPasswordSubmitted event,
    Emitter<SetPasswordState> emit,
  ) async {
    emit(const SetPasswordLoading());

    try {
      await authRepository.setPassword(
        otpId: event.otpId,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      emit(
        const SetPasswordSuccess(
          'Password set successfully',
        ),
      );
    } catch (e) {
      emit(
        SetPasswordFailure(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}