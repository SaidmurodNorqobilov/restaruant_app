// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeliveryState {
  Status get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<DeliveryModel> get deliveries => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeliveryStateCopyWith<DeliveryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryStateCopyWith<$Res> {
  factory $DeliveryStateCopyWith(
          DeliveryState value, $Res Function(DeliveryState) then) =
      _$DeliveryStateCopyWithImpl<$Res, DeliveryState>;
  @useResult
  $Res call(
      {Status status, String? errorMessage, List<DeliveryModel> deliveries});
}

/// @nodoc
class _$DeliveryStateCopyWithImpl<$Res, $Val extends DeliveryState>
    implements $DeliveryStateCopyWith<$Res> {
  _$DeliveryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? deliveries = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveries: null == deliveries
          ? _value.deliveries
          : deliveries // ignore: cast_nullable_to_non_nullable
              as List<DeliveryModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryStateImplCopyWith<$Res>
    implements $DeliveryStateCopyWith<$Res> {
  factory _$$DeliveryStateImplCopyWith(
          _$DeliveryStateImpl value, $Res Function(_$DeliveryStateImpl) then) =
      __$$DeliveryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Status status, String? errorMessage, List<DeliveryModel> deliveries});
}

/// @nodoc
class __$$DeliveryStateImplCopyWithImpl<$Res>
    extends _$DeliveryStateCopyWithImpl<$Res, _$DeliveryStateImpl>
    implements _$$DeliveryStateImplCopyWith<$Res> {
  __$$DeliveryStateImplCopyWithImpl(
      _$DeliveryStateImpl _value, $Res Function(_$DeliveryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? deliveries = null,
  }) {
    return _then(_$DeliveryStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveries: null == deliveries
          ? _value._deliveries
          : deliveries // ignore: cast_nullable_to_non_nullable
              as List<DeliveryModel>,
    ));
  }
}

/// @nodoc

class _$DeliveryStateImpl implements _DeliveryState {
  const _$DeliveryStateImpl(
      {required this.status,
      this.errorMessage,
      required final List<DeliveryModel> deliveries})
      : _deliveries = deliveries;

  @override
  final Status status;
  @override
  final String? errorMessage;
  final List<DeliveryModel> _deliveries;
  @override
  List<DeliveryModel> get deliveries {
    if (_deliveries is EqualUnmodifiableListView) return _deliveries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deliveries);
  }

  @override
  String toString() {
    return 'DeliveryState(status: $status, errorMessage: $errorMessage, deliveries: $deliveries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._deliveries, _deliveries));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, errorMessage,
      const DeepCollectionEquality().hash(_deliveries));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryStateImplCopyWith<_$DeliveryStateImpl> get copyWith =>
      __$$DeliveryStateImplCopyWithImpl<_$DeliveryStateImpl>(this, _$identity);
}

abstract class _DeliveryState implements DeliveryState {
  const factory _DeliveryState(
      {required final Status status,
      final String? errorMessage,
      required final List<DeliveryModel> deliveries}) = _$DeliveryStateImpl;

  @override
  Status get status;
  @override
  String? get errorMessage;
  @override
  List<DeliveryModel> get deliveries;
  @override
  @JsonKey(ignore: true)
  _$$DeliveryStateImplCopyWith<_$DeliveryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
