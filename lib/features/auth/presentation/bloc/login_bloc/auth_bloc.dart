import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_event.dart';
import 'package:medtech_project/features/auth/presentation/bloc/login_bloc/auth_state.dart';
import 'package:medtech_project/features/auth/domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthIntial()) {
    on<LoginSubmited>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<LoginOtpRequested>(_onLoginOtpRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmited event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final result = await authRepository.login(
        email: event.email,
        password: event.password,
      );

      final mustChangePassword = result['mustChangePassword'] as bool;

      final passwordSetupToken = result['passwordSetupToken'] as String?;

      emit(
        LoginSucess(
          mustChangePassword: mustChangePassword,
          passwordSetupToken: passwordSetupToken,
        ),
      );
    } catch (e) {
      emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoginOtpRequested(
    LoginOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await authRepository.loginOtp(
        email: event.email,
        // deviceId: event.deviceId,
        // appVersion: event.appVersion,
      );

    emit(
      const LoginOtpSent(),
    );
  } catch (e) {
    emit(
      LoginFailure(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      ),
    );
  }
}
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await authRepository.logout();

      emit(const LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
