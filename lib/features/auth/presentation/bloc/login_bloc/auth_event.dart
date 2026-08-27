abstract class AuthEvent {
  const AuthEvent();
}

class LoginSubmited extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmited({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
class LoginOtpRequested extends AuthEvent {
  final String email;

  const LoginOtpRequested({
    required this.email,
  });
}