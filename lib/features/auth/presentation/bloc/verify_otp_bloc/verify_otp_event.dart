abstract class VerifyOtpEvent {
  const VerifyOtpEvent();
}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String email;
  final String otp;

  const VerifyOtpSubmitted({
    required this.email,
    required this.otp,
  });
}

class ResendOtpRequested extends VerifyOtpEvent {
  final String email;

  const ResendOtpRequested({
    required this.email,
  });
}