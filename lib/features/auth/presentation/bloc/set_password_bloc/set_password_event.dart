abstract class SetPasswordEvent {
  const SetPasswordEvent();
}

class SetPasswordSubmitted extends SetPasswordEvent {
  final String password;
  final String confirmPassword;
  final String passwordSetupToken;
  const SetPasswordSubmitted({
    required this.password,
    required this.confirmPassword,
     required this.passwordSetupToken,
  });
}