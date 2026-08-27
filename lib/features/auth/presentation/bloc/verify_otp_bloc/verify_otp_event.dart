abstract class VerifyOtpEvent {
  const VerifyOtpEvent();
}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String email;
  final String otp;
    //final String accessToken;

  const VerifyOtpSubmitted({
    required this.email,
    required this.otp,
     //   required this.accessToken,

  });
}

class ResendOtpRequested extends VerifyOtpEvent {
  final String email;

  const ResendOtpRequested({
    required this.email,
  });
}