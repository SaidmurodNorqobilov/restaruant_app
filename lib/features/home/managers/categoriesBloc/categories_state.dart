import '../../../../core/utils/status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/models/category_model.dart';

part 'categories_state.freezed.dart';

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    required Status status,
    required List<CategoryModel> categories,
    required List<ProductModel> products,
    String? errorMessage,
  }) = _CategoriesState;

  factory CategoriesState.initial() => const CategoriesState(
    status: Status.initial,
    categories: [],
    products: [],
    errorMessage: null,
  );
}
