abstract class VerifyOtpState {
  const VerifyOtpState();
}

class VerifyOtpInitial extends VerifyOtpState {
  const VerifyOtpInitial();
}

class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading();
}

class VerifyOtpSuccess extends VerifyOtpState {
  final String otpId;

  const VerifyOtpSuccess({
    required this.otpId,
  });
}

class VerifyOtpFailure extends VerifyOtpState {
  final String message;

  const VerifyOtpFailure(this.message);
}

class ResendOtpLoading extends VerifyOtpState {
  const ResendOtpLoading();
}

class ResendOtpSuccess extends VerifyOtpState {
  const ResendOtpSuccess();
}

class ResendOtpFailure extends VerifyOtpState {
  final String message;

  const ResendOtpFailure(
    this.message,
  );
}