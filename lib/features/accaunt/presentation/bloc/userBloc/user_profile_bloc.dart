import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/features/accaunt/presentation/bloc/userBloc/user_profile_state.dart';
import 'package:restaurantapp/features/accaunt/data/repositores/user_profile_repository.dart';
import 'package:restaurantapp/features/accaunt/data/models/user_profile_model.dart';
import 'package:restaurantapp/core/utils/status.dart';
import '../../../../auth/data/datasources/user_service.dart';

part 'user_profile_event.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileRepository _repository;

  UserProfileBloc({required UserProfileRepository repository})
    : _repository = repository,
      super(UserProfileState.initial()) {
    on<GetUserProfile>(_onGetUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onGetUserProfile(
    GetUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _repository.getUserProfile();

    await result.fold(
      (error) async {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ),
        );
      },
      (data) async {
        await UserService.saveUserData(
          firstName: data.firstName ?? '',
          lastName: data.lastName ?? '',
          imagePath: data.image,
        );
        await UserService.savePhoneNumber(data.phone);
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: Status.success,
              user: data,
              errorMessage: null,
            ),
          );
        }
      },
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(
      state.copyWith(status: Status.loading),
    );
    final postModel = UserProfilePostModel(
      firstName: event.firstName,
      lastName: event.lastName,
      imageFile: event.imageFile,
    );


    final result = await _repository.patchUserProfile(postModel);

    await result.fold(
      (error) async {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: Status.error,
              errorMessage: error.toString(),
            ),
          );
        }
      },
      (data) async {
        await UserService.saveUserData(
          firstName: data.firstName ?? '',
          lastName: data.lastName ?? '',
          imagePath: data.image,
        );
        await UserService.savePhoneNumber(data.phone);
        // Keyin success holatini yuboramiz
        if (!emit.isDone) {
          emit(
            state.copyWith(
              status: Status.success,
              user: data,
              errorMessage: null,
            ),
          );
        }
      },
    );
  }

  Future<void> _saveLocalData(UserProfileModel data) async {
    await UserService.saveUserData(
      firstName: data.firstName ?? '',
      lastName: data.lastName ?? '',
      imagePath: data.image,
    );
    await UserService.savePhoneNumber(data.phone);
  }
}
