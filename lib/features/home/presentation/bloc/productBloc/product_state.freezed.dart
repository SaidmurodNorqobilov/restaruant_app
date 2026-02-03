// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProductState {
  Status get status => throw _privateConstructorUsedError;
  List<ProductModelItem> get products => throw _privateConstructorUsedError;
  ProductItemModel? get selectedProduct => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Map<String, dynamic>? get lastAddedItemResponse =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProductStateCopyWith<ProductState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductStateCopyWith<$Res> {
  factory $ProductStateCopyWith(
          ProductState value, $Res Function(ProductState) then) =
      _$ProductStateCopyWithImpl<$Res, ProductState>;
  @useResult
  $Res call(
      {Status status,
      List<ProductModelItem> products,
      ProductItemModel? selectedProduct,
      String? errorMessage,
      Map<String, dynamic>? lastAddedItemResponse});
}

/// @nodoc
class _$ProductStateCopyWithImpl<$Res, $Val extends ProductState>
    implements $ProductStateCopyWith<$Res> {
  _$ProductStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? products = null,
    Object? selectedProduct = freezed,
    Object? errorMessage = freezed,
    Object? lastAddedItemResponse = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModelItem>,
      selectedProduct: freezed == selectedProduct
          ? _value.selectedProduct
          : selectedProduct // ignore: cast_nullable_to_non_nullable
              as ProductItemModel?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAddedItemResponse: freezed == lastAddedItemResponse
          ? _value.lastAddedItemResponse
          : lastAddedItemResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductStateImplCopyWith<$Res>
    implements $ProductStateCopyWith<$Res> {
  factory _$$ProductStateImplCopyWith(
          _$ProductStateImpl value, $Res Function(_$ProductStateImpl) then) =
      __$$ProductStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Status status,
      List<ProductModelItem> products,
      ProductItemModel? selectedProduct,
      String? errorMessage,
      Map<String, dynamic>? lastAddedItemResponse});
}

/// @nodoc
class __$$ProductStateImplCopyWithImpl<$Res>
    extends _$ProductStateCopyWithImpl<$Res, _$ProductStateImpl>
    implements _$$ProductStateImplCopyWith<$Res> {
  __$$ProductStateImplCopyWithImpl(
      _$ProductStateImpl _value, $Res Function(_$ProductStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? products = null,
    Object? selectedProduct = freezed,
    Object? errorMessage = freezed,
    Object? lastAddedItemResponse = freezed,
  }) {
    return _then(_$ProductStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModelItem>,
      selectedProduct: freezed == selectedProduct
          ? _value.selectedProduct
          : selectedProduct // ignore: cast_nullable_to_non_nullable
              as ProductItemModel?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAddedItemResponse: freezed == lastAddedItemResponse
          ? _value._lastAddedItemResponse
          : lastAddedItemResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$ProductStateImpl implements _ProductState {
  const _$ProductStateImpl(
      {required this.status,
      required final List<ProductModelItem> products,
      this.selectedProduct,
      this.errorMessage,
      final Map<String, dynamic>? lastAddedItemResponse})
      : _products = products,
        _lastAddedItemResponse = lastAddedItemResponse;

  @override
  final Status status;
  final List<ProductModelItem> _products;
  @override
  List<ProductModelItem> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final ProductItemModel? selectedProduct;
  @override
  final String? errorMessage;
  final Map<String, dynamic>? _lastAddedItemResponse;
  @override
  Map<String, dynamic>? get lastAddedItemResponse {
    final value = _lastAddedItemResponse;
    if (value == null) return null;
    if (_lastAddedItemResponse is EqualUnmodifiableMapView)
      return _lastAddedItemResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ProductState(status: $status, products: $products, selectedProduct: $selectedProduct, errorMessage: $errorMessage, lastAddedItemResponse: $lastAddedItemResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.selectedProduct, selectedProduct) ||
                other.selectedProduct == selectedProduct) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._lastAddedItemResponse, _lastAddedItemResponse));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_products),
      selectedProduct,
      errorMessage,
      const DeepCollectionEquality().hash(_lastAddedItemResponse));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductStateImplCopyWith<_$ProductStateImpl> get copyWith =>
      __$$ProductStateImplCopyWithImpl<_$ProductStateImpl>(this, _$identity);
}

abstract class _ProductState implements ProductState {
  const factory _ProductState(
      {required final Status status,
      required final List<ProductModelItem> products,
      final ProductItemModel? selectedProduct,
      final String? errorMessage,
      final Map<String, dynamic>? lastAddedItemResponse}) = _$ProductStateImpl;

  @override
  Status get status;
  @override
  List<ProductModelItem> get products;
  @override
  ProductItemModel? get selectedProduct;
  @override
  String? get errorMessage;
  @override
  Map<String, dynamic>? get lastAddedItemResponse;
  @override
  @JsonKey(ignore: true)
  _$$ProductStateImplCopyWith<_$ProductStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
