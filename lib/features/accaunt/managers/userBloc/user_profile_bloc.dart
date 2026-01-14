import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/data/repositories/user_profile_repository.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/accaunt/managers/userBloc/user_profile_state.dart';
import '../../../../core/network/user_service.dart';
part 'user_profile_event.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileRepository _repository;

  UserProfileBloc({required UserProfileRepository repository})
      : _repository = repository,
        super(UserProfileState.initial()) {
    on<GetUserProfile>(_onGetUserProfile);
  }

  Future<void> _onGetUserProfile(
      GetUserProfile event,
      Emitter<UserProfileState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _repository.getUserProfile();

    await result.fold(
          (error) async => emit(
        state.copyWith(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      ),
          (data) async {
        await UserService.saveUserData(
          firstName: data.firstName,
          lastName: data.lastName,
          region: data.address,
          imagePath: data.image,
        );
        await UserService.savePhoneNumber(data.phone);

        emit(
          state.copyWith(
            status: Status.success,
            user: data,
            errorMessage: null,
          ),
        );
      },
    );
  }
}