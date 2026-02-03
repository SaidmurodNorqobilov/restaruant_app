import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/accaunt/data/models/user_profile_model.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    required Status status,
    String? errorMessage,
    UserProfileModel? user,
  }) = _ProfileState;

  factory ProfileState.initial() =>  ProfileState(
    status: Status.initial,
    errorMessage: null,
    user: null,
  );
}