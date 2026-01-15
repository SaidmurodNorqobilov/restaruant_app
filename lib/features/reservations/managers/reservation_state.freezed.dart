// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReservationState {
  Status get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Map<String, dynamic>? get addedReservationResponse =>
      throw _privateConstructorUsedError;
  List<ReservationModel>? get reservations =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get updatedReservationResponse =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get canceledReservationResponse =>
      throw _privateConstructorUsedError;

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationStateCopyWith<ReservationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationStateCopyWith<$Res> {
  factory $ReservationStateCopyWith(
    ReservationState value,
    $Res Function(ReservationState) then,
  ) = _$ReservationStateCopyWithImpl<$Res, ReservationState>;
  @useResult
  $Res call({
    Status status,
    String? errorMessage,
    Map<String, dynamic>? addedReservationResponse,
    List<ReservationModel>? reservations,
    Map<String, dynamic>? updatedReservationResponse,
    Map<String, dynamic>? canceledReservationResponse,
  });
}

/// @nodoc
class _$ReservationStateCopyWithImpl<$Res, $Val extends ReservationState>
    implements $ReservationStateCopyWith<$Res> {
  _$ReservationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? addedReservationResponse = freezed,
    Object? reservations = freezed,
    Object? updatedReservationResponse = freezed,
    Object? canceledReservationResponse = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as Status,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            addedReservationResponse: freezed == addedReservationResponse
                ? _value.addedReservationResponse
                : addedReservationResponse // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            reservations: freezed == reservations
                ? _value.reservations
                : reservations // ignore: cast_nullable_to_non_nullable
                      as List<ReservationModel>?,
            updatedReservationResponse: freezed == updatedReservationResponse
                ? _value.updatedReservationResponse
                : updatedReservationResponse // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            canceledReservationResponse: freezed == canceledReservationResponse
                ? _value.canceledReservationResponse
                : canceledReservationResponse // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReservationStateImplCopyWith<$Res>
    implements $ReservationStateCopyWith<$Res> {
  factory _$$ReservationStateImplCopyWith(
    _$ReservationStateImpl value,
    $Res Function(_$ReservationStateImpl) then,
  ) = __$$ReservationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Status status,
    String? errorMessage,
    Map<String, dynamic>? addedReservationResponse,
    List<ReservationModel>? reservations,
    Map<String, dynamic>? updatedReservationResponse,
    Map<String, dynamic>? canceledReservationResponse,
  });
}

/// @nodoc
class __$$ReservationStateImplCopyWithImpl<$Res>
    extends _$ReservationStateCopyWithImpl<$Res, _$ReservationStateImpl>
    implements _$$ReservationStateImplCopyWith<$Res> {
  __$$ReservationStateImplCopyWithImpl(
    _$ReservationStateImpl _value,
    $Res Function(_$ReservationStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? addedReservationResponse = freezed,
    Object? reservations = freezed,
    Object? updatedReservationResponse = freezed,
    Object? canceledReservationResponse = freezed,
  }) {
    return _then(
      _$ReservationStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as Status,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        addedReservationResponse: freezed == addedReservationResponse
            ? _value._addedReservationResponse
            : addedReservationResponse // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        reservations: freezed == reservations
            ? _value._reservations
            : reservations // ignore: cast_nullable_to_non_nullable
                  as List<ReservationModel>?,
        updatedReservationResponse: freezed == updatedReservationResponse
            ? _value._updatedReservationResponse
            : updatedReservationResponse // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        canceledReservationResponse: freezed == canceledReservationResponse
            ? _value._canceledReservationResponse
            : canceledReservationResponse // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$ReservationStateImpl implements _ReservationState {
  const _$ReservationStateImpl({
    required this.status,
    this.errorMessage,
    final Map<String, dynamic>? addedReservationResponse,
    final List<ReservationModel>? reservations,
    final Map<String, dynamic>? updatedReservationResponse,
    final Map<String, dynamic>? canceledReservationResponse,
  }) : _addedReservationResponse = addedReservationResponse,
       _reservations = reservations,
       _updatedReservationResponse = updatedReservationResponse,
       _canceledReservationResponse = canceledReservationResponse;

  @override
  final Status status;
  @override
  final String? errorMessage;
  final Map<String, dynamic>? _addedReservationResponse;
  @override
  Map<String, dynamic>? get addedReservationResponse {
    final value = _addedReservationResponse;
    if (value == null) return null;
    if (_addedReservationResponse is EqualUnmodifiableMapView)
      return _addedReservationResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<ReservationModel>? _reservations;
  @override
  List<ReservationModel>? get reservations {
    final value = _reservations;
    if (value == null) return null;
    if (_reservations is EqualUnmodifiableListView) return _reservations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _updatedReservationResponse;
  @override
  Map<String, dynamic>? get updatedReservationResponse {
    final value = _updatedReservationResponse;
    if (value == null) return null;
    if (_updatedReservationResponse is EqualUnmodifiableMapView)
      return _updatedReservationResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _canceledReservationResponse;
  @override
  Map<String, dynamic>? get canceledReservationResponse {
    final value = _canceledReservationResponse;
    if (value == null) return null;
    if (_canceledReservationResponse is EqualUnmodifiableMapView)
      return _canceledReservationResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ReservationState(status: $status, errorMessage: $errorMessage, addedReservationResponse: $addedReservationResponse, reservations: $reservations, updatedReservationResponse: $updatedReservationResponse, canceledReservationResponse: $canceledReservationResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(
              other._addedReservationResponse,
              _addedReservationResponse,
            ) &&
            const DeepCollectionEquality().equals(
              other._reservations,
              _reservations,
            ) &&
            const DeepCollectionEquality().equals(
              other._updatedReservationResponse,
              _updatedReservationResponse,
            ) &&
            const DeepCollectionEquality().equals(
              other._canceledReservationResponse,
              _canceledReservationResponse,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    errorMessage,
    const DeepCollectionEquality().hash(_addedReservationResponse),
    const DeepCollectionEquality().hash(_reservations),
    const DeepCollectionEquality().hash(_updatedReservationResponse),
    const DeepCollectionEquality().hash(_canceledReservationResponse),
  );

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationStateImplCopyWith<_$ReservationStateImpl> get copyWith =>
      __$$ReservationStateImplCopyWithImpl<_$ReservationStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ReservationState implements ReservationState {
  const factory _ReservationState({
    required final Status status,
    final String? errorMessage,
    final Map<String, dynamic>? addedReservationResponse,
    final List<ReservationModel>? reservations,
    final Map<String, dynamic>? updatedReservationResponse,
    final Map<String, dynamic>? canceledReservationResponse,
  }) = _$ReservationStateImpl;

  @override
  Status get status;
  @override
  String? get errorMessage;
  @override
  Map<String, dynamic>? get addedReservationResponse;
  @override
  List<ReservationModel>? get reservations;
  @override
  Map<String, dynamic>? get updatedReservationResponse;
  @override
  Map<String, dynamic>? get canceledReservationResponse;

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationStateImplCopyWith<_$ReservationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
