// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrdersState {
  Status get status => throw _privateConstructorUsedError;
  List<OrderModel> get orders => throw _privateConstructorUsedError;
  Map<String, dynamic>? get cancelOrder => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrdersStateCopyWith<OrdersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersStateCopyWith<$Res> {
  factory $OrdersStateCopyWith(
          OrdersState value, $Res Function(OrdersState) then) =
      _$OrdersStateCopyWithImpl<$Res, OrdersState>;
  @useResult
  $Res call(
      {Status status,
      List<OrderModel> orders,
      Map<String, dynamic>? cancelOrder,
      String? errorMessage});
}

/// @nodoc
class _$OrdersStateCopyWithImpl<$Res, $Val extends OrdersState>
    implements $OrdersStateCopyWith<$Res> {
  _$OrdersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? orders = null,
    Object? cancelOrder = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
      cancelOrder: freezed == cancelOrder
          ? _value.cancelOrder
          : cancelOrder // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrdersStateImplCopyWith<$Res>
    implements $OrdersStateCopyWith<$Res> {
  factory _$$OrdersStateImplCopyWith(
          _$OrdersStateImpl value, $Res Function(_$OrdersStateImpl) then) =
      __$$OrdersStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Status status,
      List<OrderModel> orders,
      Map<String, dynamic>? cancelOrder,
      String? errorMessage});
}

/// @nodoc
class __$$OrdersStateImplCopyWithImpl<$Res>
    extends _$OrdersStateCopyWithImpl<$Res, _$OrdersStateImpl>
    implements _$$OrdersStateImplCopyWith<$Res> {
  __$$OrdersStateImplCopyWithImpl(
      _$OrdersStateImpl _value, $Res Function(_$OrdersStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? orders = null,
    Object? cancelOrder = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$OrdersStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      orders: null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
      cancelOrder: freezed == cancelOrder
          ? _value._cancelOrder
          : cancelOrder // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OrdersStateImpl implements _OrdersState {
  const _$OrdersStateImpl(
      {required this.status,
      required final List<OrderModel> orders,
      final Map<String, dynamic>? cancelOrder,
      this.errorMessage})
      : _orders = orders,
        _cancelOrder = cancelOrder;

  @override
  final Status status;
  final List<OrderModel> _orders;
  @override
  List<OrderModel> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  final Map<String, dynamic>? _cancelOrder;
  @override
  Map<String, dynamic>? get cancelOrder {
    final value = _cancelOrder;
    if (value == null) return null;
    if (_cancelOrder is EqualUnmodifiableMapView) return _cancelOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'OrdersState(status: $status, orders: $orders, cancelOrder: $cancelOrder, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            const DeepCollectionEquality()
                .equals(other._cancelOrder, _cancelOrder) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_orders),
      const DeepCollectionEquality().hash(_cancelOrder),
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersStateImplCopyWith<_$OrdersStateImpl> get copyWith =>
      __$$OrdersStateImplCopyWithImpl<_$OrdersStateImpl>(this, _$identity);
}

abstract class _OrdersState implements OrdersState {
  const factory _OrdersState(
      {required final Status status,
      required final List<OrderModel> orders,
      final Map<String, dynamic>? cancelOrder,
      final String? errorMessage}) = _$OrdersStateImpl;

  @override
  Status get status;
  @override
  List<OrderModel> get orders;
  @override
  Map<String, dynamic>? get cancelOrder;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$OrdersStateImplCopyWith<_$OrdersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
