abstract class ResetPasswordEvent {
  const ResetPasswordEvent();
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String otpId;
  final String email;
  final String password;
  final String confirmPassword;

  const ResetPasswordSubmitted({
    required this.otpId,
   required this.email,
    required this.password,
    required this.confirmPassword,
  });
}