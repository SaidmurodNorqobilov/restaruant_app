// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CartState {
  Status get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<CartModel>? get cart => throw _privateConstructorUsedError;
  Map<String, dynamic>? get updatedCartResponse =>
      throw _privateConstructorUsedError;
  int? get itemId => throw _privateConstructorUsedError;
  double? get totalPrice => throw _privateConstructorUsedError;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartStateCopyWith<CartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartStateCopyWith<$Res> {
  factory $CartStateCopyWith(CartState value, $Res Function(CartState) then) =
      _$CartStateCopyWithImpl<$Res, CartState>;
  @useResult
  $Res call({
    Status status,
    String? errorMessage,
    List<CartModel>? cart,
    Map<String, dynamic>? updatedCartResponse,
    int? itemId,
    double? totalPrice,
  });
}

/// @nodoc
class _$CartStateCopyWithImpl<$Res, $Val extends CartState>
    implements $CartStateCopyWith<$Res> {
  _$CartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? cart = freezed,
    Object? updatedCartResponse = freezed,
    Object? itemId = freezed,
    Object? totalPrice = freezed,
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
            cart: freezed == cart
                ? _value.cart
                : cart // ignore: cast_nullable_to_non_nullable
                      as List<CartModel>?,
            updatedCartResponse: freezed == updatedCartResponse
                ? _value.updatedCartResponse
                : updatedCartResponse // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            itemId: freezed == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalPrice: freezed == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartStateImplCopyWith<$Res>
    implements $CartStateCopyWith<$Res> {
  factory _$$CartStateImplCopyWith(
    _$CartStateImpl value,
    $Res Function(_$CartStateImpl) then,
  ) = __$$CartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Status status,
    String? errorMessage,
    List<CartModel>? cart,
    Map<String, dynamic>? updatedCartResponse,
    int? itemId,
    double? totalPrice,
  });
}

/// @nodoc
class __$$CartStateImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$CartStateImpl>
    implements _$$CartStateImplCopyWith<$Res> {
  __$$CartStateImplCopyWithImpl(
    _$CartStateImpl _value,
    $Res Function(_$CartStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? cart = freezed,
    Object? updatedCartResponse = freezed,
    Object? itemId = freezed,
    Object? totalPrice = freezed,
  }) {
    return _then(
      _$CartStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as Status,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        cart: freezed == cart
            ? _value._cart
            : cart // ignore: cast_nullable_to_non_nullable
                  as List<CartModel>?,
        updatedCartResponse: freezed == updatedCartResponse
            ? _value._updatedCartResponse
            : updatedCartResponse // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        itemId: freezed == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalPrice: freezed == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$CartStateImpl implements _CartState {
  const _$CartStateImpl({
    required this.status,
    this.errorMessage,
    final List<CartModel>? cart,
    final Map<String, dynamic>? updatedCartResponse,
    this.itemId,
    this.totalPrice,
  }) : _cart = cart,
       _updatedCartResponse = updatedCartResponse;

  @override
  final Status status;
  @override
  final String? errorMessage;
  final List<CartModel>? _cart;
  @override
  List<CartModel>? get cart {
    final value = _cart;
    if (value == null) return null;
    if (_cart is EqualUnmodifiableListView) return _cart;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _updatedCartResponse;
  @override
  Map<String, dynamic>? get updatedCartResponse {
    final value = _updatedCartResponse;
    if (value == null) return null;
    if (_updatedCartResponse is EqualUnmodifiableMapView)
      return _updatedCartResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final int? itemId;
  @override
  final double? totalPrice;

  @override
  String toString() {
    return 'CartState(status: $status, errorMessage: $errorMessage, cart: $cart, updatedCartResponse: $updatedCartResponse, itemId: $itemId, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._cart, _cart) &&
            const DeepCollectionEquality().equals(
              other._updatedCartResponse,
              _updatedCartResponse,
            ) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    errorMessage,
    const DeepCollectionEquality().hash(_cart),
    const DeepCollectionEquality().hash(_updatedCartResponse),
    itemId,
    totalPrice,
  );

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartStateImplCopyWith<_$CartStateImpl> get copyWith =>
      __$$CartStateImplCopyWithImpl<_$CartStateImpl>(this, _$identity);
}

abstract class _CartState implements CartState {
  const factory _CartState({
    required final Status status,
    final String? errorMessage,
    final List<CartModel>? cart,
    final Map<String, dynamic>? updatedCartResponse,
    final int? itemId,
    final double? totalPrice,
  }) = _$CartStateImpl;

  @override
  Status get status;
  @override
  String? get errorMessage;
  @override
  List<CartModel>? get cart;
  @override
  Map<String, dynamic>? get updatedCartResponse;
  @override
  int? get itemId;
  @override
  double? get totalPrice;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartStateImplCopyWith<_$CartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
