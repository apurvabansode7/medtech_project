abstract class VerifyOtpEvent {
  const VerifyOtpEvent();
}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String email;
  final String otp;
  final String deviceId;
  final String appVersion;
  final String platform;

  const VerifyOtpSubmitted({
    required this.email,
    required this.otp,
    required this.deviceId,
    required this.appVersion,
     required this.platform,
  });
}

class ResendOtpRequested extends VerifyOtpEvent {
  final String email;
  final String deviceId;
  final String appVersion;

  const ResendOtpRequested({
    required this.email,
    required this.deviceId,
    required this.appVersion,
  });
}