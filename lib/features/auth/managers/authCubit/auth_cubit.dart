import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial());

  final AuthRepository _authRepository;

  Future<void> sendPhone(String phone) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _authRepository.sendPhone(phone);

    result.fold(
          (error) => emit(
        state.copyWith(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      ),
          (sessionId) => emit(
        state.copyWith(
          status: Status.success,
          sessionId: sessionId,
        ),
      ),
    );
  }

  Future<void> verifyCode(String sessionId, String code) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _authRepository.verifyCode(sessionId, code);

    result.fold(
          (error) => emit(state.copyWith(
        status: Status.error,
        errorMessage: error.toString(),
      )),
          (data) {
        emit(state.copyWith(
          status: Status.success,
          isAuthenticated: true,
          isNewUser: data['is_new_user'] ?? false,
        ));
      },
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthState.initial());
  }

  void clearError() {
    if (state.status == Status.error) {
      emit(state.copyWith(status: Status.initial, errorMessage: null));
    }
  }
}
