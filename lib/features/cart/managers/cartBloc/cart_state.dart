import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurantapp/data/models/cart_model.dart';

import '../../../../core/utils/status.dart';

part 'cart_state.freezed.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({
    required Status status,
    String? errorMessage,
    List<CartModel>? cart,
    Map<String, dynamic>? updatedCartResponse,
    int? itemId,
    double? totalPrice,
  }) = _CartState;

  factory CartState.initial() => const CartState(
    status: Status.initial,
    errorMessage: null,
    cart: [],
    updatedCartResponse: null,
    itemId: 0,
    totalPrice: 0.0,
  );
}