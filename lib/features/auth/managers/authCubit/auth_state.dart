import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurantapp/core/utils/status.dart';
part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    required Status status,
    String? errorMessage,
    String? sessionId,
    required bool isAuthenticated,
    required bool isNewUser,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState(
    status: Status.initial,
    errorMessage: null,
    sessionId: null,
    isAuthenticated: false,
    isNewUser: false,
  );
}