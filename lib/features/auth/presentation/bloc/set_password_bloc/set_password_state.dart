abstract class SetPasswordState {
  const SetPasswordState();
}

class SetPasswordInitial extends SetPasswordState {
  const SetPasswordInitial();
}

class SetPasswordLoading extends SetPasswordState {
  const SetPasswordLoading();
}

class SetPasswordSuccess extends SetPasswordState {
  final String message;

  const SetPasswordSuccess([this.message = 'Password set successfully']);
}

class SetPasswordFailure extends SetPasswordState {
  final String message;

  const SetPasswordFailure(this.message);
}
