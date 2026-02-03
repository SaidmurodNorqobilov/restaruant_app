// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategoriesState {
  Status get status => throw _privateConstructorUsedError;
  List<CategoryModel> get categories => throw _privateConstructorUsedError;
  List<ProductModelItem> get products => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get hasReachedMax => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CategoriesStateCopyWith<CategoriesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoriesStateCopyWith<$Res> {
  factory $CategoriesStateCopyWith(
          CategoriesState value, $Res Function(CategoriesState) then) =
      _$CategoriesStateCopyWithImpl<$Res, CategoriesState>;
  @useResult
  $Res call(
      {Status status,
      List<CategoryModel> categories,
      List<ProductModelItem> products,
      String? errorMessage,
      bool hasReachedMax,
      bool isLoadingMore});
}

/// @nodoc
class _$CategoriesStateCopyWithImpl<$Res, $Val extends CategoriesState>
    implements $CategoriesStateCopyWith<$Res> {
  _$CategoriesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? categories = null,
    Object? products = null,
    Object? errorMessage = freezed,
    Object? hasReachedMax = null,
    Object? isLoadingMore = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModelItem>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoriesStateImplCopyWith<$Res>
    implements $CategoriesStateCopyWith<$Res> {
  factory _$$CategoriesStateImplCopyWith(_$CategoriesStateImpl value,
          $Res Function(_$CategoriesStateImpl) then) =
      __$$CategoriesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Status status,
      List<CategoryModel> categories,
      List<ProductModelItem> products,
      String? errorMessage,
      bool hasReachedMax,
      bool isLoadingMore});
}

/// @nodoc
class __$$CategoriesStateImplCopyWithImpl<$Res>
    extends _$CategoriesStateCopyWithImpl<$Res, _$CategoriesStateImpl>
    implements _$$CategoriesStateImplCopyWith<$Res> {
  __$$CategoriesStateImplCopyWithImpl(
      _$CategoriesStateImpl _value, $Res Function(_$CategoriesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? categories = null,
    Object? products = null,
    Object? errorMessage = freezed,
    Object? hasReachedMax = null,
    Object? isLoadingMore = null,
  }) {
    return _then(_$CategoriesStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModelItem>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CategoriesStateImpl implements _CategoriesState {
  const _$CategoriesStateImpl(
      {required this.status,
      required final List<CategoryModel> categories,
      required final List<ProductModelItem> products,
      this.errorMessage,
      this.hasReachedMax = false,
      this.isLoadingMore = false})
      : _categories = categories,
        _products = products;

  @override
  final Status status;
  final List<CategoryModel> _categories;
  @override
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<ProductModelItem> _products;
  @override
  List<ProductModelItem> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool hasReachedMax;
  @override
  @JsonKey()
  final bool isLoadingMore;

  @override
  String toString() {
    return 'CategoriesState(status: $status, categories: $categories, products: $products, errorMessage: $errorMessage, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoriesStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_products),
      errorMessage,
      hasReachedMax,
      isLoadingMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoriesStateImplCopyWith<_$CategoriesStateImpl> get copyWith =>
      __$$CategoriesStateImplCopyWithImpl<_$CategoriesStateImpl>(
          this, _$identity);
}

abstract class _CategoriesState implements CategoriesState {
  const factory _CategoriesState(
      {required final Status status,
      required final List<CategoryModel> categories,
      required final List<ProductModelItem> products,
      final String? errorMessage,
      final bool hasReachedMax,
      final bool isLoadingMore}) = _$CategoriesStateImpl;

  @override
  Status get status;
  @override
  List<CategoryModel> get categories;
  @override
  List<ProductModelItem> get products;
  @override
  String? get errorMessage;
  @override
  bool get hasReachedMax;
  @override
  bool get isLoadingMore;
  @override
  @JsonKey(ignore: true)
  _$$CategoriesStateImplCopyWith<_$CategoriesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
