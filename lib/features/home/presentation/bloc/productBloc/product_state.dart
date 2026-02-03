import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurantapp/features/home/data/models/product_item_model.dart';

import '../../../../../core/utils/status.dart';
import '../../../data/models/category_model.dart';

part 'product_state.freezed.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState({
    required Status status,
    required List<ProductModelItem> products,
    ProductItemModel? selectedProduct,
    String? errorMessage,
    Map<String, dynamic>? lastAddedItemResponse,
  }) = _ProductState;

  factory ProductState.initial() => const ProductState(
    status: Status.initial,
    products: [],
    selectedProduct: null,
    errorMessage: null,
    lastAddedItemResponse: null,
  );
}