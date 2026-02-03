part of 'cart_bloc.dart';

sealed class CartEvent {}

final class CartLoading extends CartEvent {}

final class CartUpdate extends CartEvent {
  final String itemId;
  final int quantity;

  CartUpdate({required this.itemId, required this.quantity});
}

final class DeleteCartItem extends CartEvent {
  final int itemId;

  DeleteCartItem({required this.itemId});
}


