import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medtech_project/features/profile/domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({
    required this.repository,
  }) : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    try {
      final profile = await repository.getProfile();

      emit(
        ProfileLoaded(
          profile: profile,
        ),
      );
    } catch (e) {
      emit(
        ProfileFailure(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileUpdateLoading());

    try {
      final profile = await repository.updateProfile(
        data: event.data,
        
      );

      emit(
        ProfileUpdateSuccess(
          profile: profile,
        ),
      );
    } catch (e) {
      emit(
        ProfileUpdateFailure(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

}