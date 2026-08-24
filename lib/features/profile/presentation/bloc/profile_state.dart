
import 'package:medtech_project/features/profile/data/models/profile_response_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileData profile;
  

  const ProfileLoaded({
    required this.profile,
  });
}


class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);
}