
import 'package:medtech_project/features/profile/data/models/profile_response_model.dart';

abstract class ProfileRepository {
  Future<ProfileData> getProfile();
}