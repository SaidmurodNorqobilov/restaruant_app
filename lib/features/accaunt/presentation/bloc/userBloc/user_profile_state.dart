import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurantapp/features/accaunt/data/models/user_profile_model.dart';
import '../../../../../core/utils/status.dart';
part 'user_profile_state.freezed.dart';

@freezed
class UserProfileState with _$UserProfileState {
  const factory UserProfileState({
    UserProfileModel? user,
    required Status status,
    String? errorMessage,
  }) = _UserProfileState;

  factory UserProfileState.initial() => const UserProfileState(
    user: null,
    status: Status.initial,
    errorMessage: null,
  );
}