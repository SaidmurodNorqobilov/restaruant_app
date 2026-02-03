import '../../../../../core/utils/status.dart';
import '../../../data/models/category_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories_state.freezed.dart';

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    required Status status,
    required List<CategoryModel> categories,
    required List<ProductModelItem> products,
    String? errorMessage,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
  }) = _CategoriesState;

  factory CategoriesState.initial() => const CategoriesState(
    status: Status.initial,
    categories: [],
    products: [],
    errorMessage: null,
    hasReachedMax: false,
    isLoadingMore: false,
  );
}