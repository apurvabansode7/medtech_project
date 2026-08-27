import 'dart:io';

abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> data;
   final File? profileImage;

  const UpdateProfile({
    required this.data,
     this.profileImage,
  });
}