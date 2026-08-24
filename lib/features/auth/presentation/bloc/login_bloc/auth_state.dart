abstract class AuthState{
  const AuthState();
}
class AuthIntial extends AuthState{
  const AuthIntial();
}

class AuthLoading extends AuthState{
  const AuthLoading();
}
class LoginSucess extends AuthState {
  final String message;

  const LoginSucess([
    this.message = 'Login successful',
  ]);
}

class LoginFailure extends AuthState{final String message;
  const LoginFailure(
    this.message
  );
}
class LogoutSuccess extends AuthState {
  final String message;
  const LogoutSuccess([ this.message = 'Log out successful']);
}
class LogoutFailure extends AuthState {
  final String message;

  const LogoutFailure(this.message);
}

