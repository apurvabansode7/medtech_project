abstract class SetPasswordEvent {
  const SetPasswordEvent();
}

class SetPasswordSubmitted extends SetPasswordEvent {
  final String otpId;
  final String password;
  final String confirmPassword;

  const SetPasswordSubmitted({
    required this.otpId,
    required this.password,
    required this.confirmPassword,
  });
}