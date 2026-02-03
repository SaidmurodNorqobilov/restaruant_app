part of 'user_profile_bloc.dart';

abstract class UserProfileEvent {}

class GetUserProfile extends UserProfileEvent {}

class UpdateUserProfile extends UserProfileEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final File? imageFile;

  UpdateUserProfile({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.imageFile,
  });
}