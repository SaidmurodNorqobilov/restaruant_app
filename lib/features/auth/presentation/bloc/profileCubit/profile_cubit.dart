import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/core/utils/status.dart';
import '../../../../cart/data/repositories/profile_repositroy.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(
        ProfileState.initial(),
      );

  final ProfileRepository _profileRepository;

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _profileRepository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      address: address,
      imageFile: imageFile,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            status: Status.success,
            user: data,
          ),
        );
      },
    );
  }

  void clearError() {
    emit(
      state.copyWith(
        status: Status.initial,
        errorMessage: null,
      ),
    );
  }
}
