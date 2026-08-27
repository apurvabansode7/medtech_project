abstract class AuthState {
  const AuthState();
}

class AuthIntial extends AuthState {
  const AuthIntial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class LoginSucess extends AuthState {
  final String message;
  final bool mustChangePassword;
  final String? passwordSetupToken;

  const LoginSucess({
    this.message = 'Login successful',
    required this.mustChangePassword,
    this.passwordSetupToken,
  });
}

class LoginFailure extends AuthState {
  final String message;
  const LoginFailure(this.message);
}

class LogoutSuccess extends AuthState {
  final String message;
  const LogoutSuccess([this.message = 'Log out successful']);
}

class LogoutFailure extends AuthState {
  final String message;

  const LogoutFailure(this.message);
}

class LoginOtpSent extends AuthState {
  final String message;
  

  const LoginOtpSent({
    this.message = 'OTP sent successfully',
      
  });
}