import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medtech_project/features/auth/domain/repositories/auth_repository.dart';

import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordBloc({
    required this.authRepository,
  }) : super(const ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(
      _onForgotPasswordSubmitted,
    );
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordLoading());

    try {
      await authRepository.forgotPassword(
        email: event.email,
      );

      emit(
        const ForgotPasswordSuccess(),
      );
    } catch (e) {
      emit(
        ForgotPasswordFailure(
          e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }
}