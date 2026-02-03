import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/core/utils/status.dart';
import 'package:restaurantapp/features/auth/data/repositories/auth_repository.dart';
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
      (_) => emit(
        state.copyWith(
          status: Status.success,
          phone: phone,
        ),
      ),
    );
  }

  Future<void> verifyCode(String phone, String code) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _authRepository.verifyCode(phone, code);
    result.fold(
      (error) => emit(
        state.copyWith(
          status: Status.error,
          errorMessage: "Kod xato kiritildi",
        ),
      ),
      (data) {
        final user = data['user'] as Map<String, dynamic>?;
        final isNewUser = user?['first_name'] == null;
        emit(
          state.copyWith(
            status: Status.success,
            isAuthenticated: true,
            isNewUser: isNewUser,
          ),
        );
      },
    );
  }

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    emit(state.copyWith(isAuthenticated: isLoggedIn));
  }

  void clearError() => emit(
    state.copyWith(status: Status.initial, errorMessage: null),
  );

  // oxirgi yozilgan kod
  Future<void> logout() async {
    emit(state.copyWith(status: Status.loading));

    final result = await _authRepository.logout();

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ),
        );
      },
      (_) {
        emit(
          AuthState.initial().copyWith(
            isAuthenticated: false,
            status: Status.success,
          ),
        );
      },
    );
  }
}
