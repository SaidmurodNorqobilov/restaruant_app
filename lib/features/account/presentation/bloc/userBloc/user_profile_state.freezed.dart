// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserProfileState {
  UserProfileModel? get user => throw _privateConstructorUsedError;
  Status get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserProfileStateCopyWith<UserProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileStateCopyWith<$Res> {
  factory $UserProfileStateCopyWith(
          UserProfileState value, $Res Function(UserProfileState) then) =
      _$UserProfileStateCopyWithImpl<$Res, UserProfileState>;
  @useResult
  $Res call({UserProfileModel? user, Status status, String? errorMessage});
}

/// @nodoc
class _$UserProfileStateCopyWithImpl<$Res, $Val extends UserProfileState>
    implements $UserProfileStateCopyWith<$Res> {
  _$UserProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfileModel?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileStateImplCopyWith<$Res>
    implements $UserProfileStateCopyWith<$Res> {
  factory _$$UserProfileStateImplCopyWith(_$UserProfileStateImpl value,
          $Res Function(_$UserProfileStateImpl) then) =
      __$$UserProfileStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserProfileModel? user, Status status, String? errorMessage});
}

/// @nodoc
class __$$UserProfileStateImplCopyWithImpl<$Res>
    extends _$UserProfileStateCopyWithImpl<$Res, _$UserProfileStateImpl>
    implements _$$UserProfileStateImplCopyWith<$Res> {
  __$$UserProfileStateImplCopyWithImpl(_$UserProfileStateImpl _value,
      $Res Function(_$UserProfileStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$UserProfileStateImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfileModel?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UserProfileStateImpl implements _UserProfileState {
  const _$UserProfileStateImpl(
      {this.user, required this.status, this.errorMessage});

  @override
  final UserProfileModel? user;
  @override
  final Status status;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'UserProfileState(user: $user, status: $status, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileStateImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, status, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileStateImplCopyWith<_$UserProfileStateImpl> get copyWith =>
      __$$UserProfileStateImplCopyWithImpl<_$UserProfileStateImpl>(
          this, _$identity);
}

abstract class _UserProfileState implements UserProfileState {
  const factory _UserProfileState(
      {final UserProfileModel? user,
      required final Status status,
      final String? errorMessage}) = _$UserProfileStateImpl;

  @override
  UserProfileModel? get user;
  @override
  Status get status;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileStateImplCopyWith<_$UserProfileStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
