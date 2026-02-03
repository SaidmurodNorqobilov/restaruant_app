part of 'product_bloc.dart';

abstract class ProductEvent {}

class GetProductsEvent extends ProductEvent {}

class GetProductDetailEvent extends ProductEvent {
  final String productId;
  GetProductDetailEvent(this.productId);
}

class AddOrderItemEvent extends ProductEvent {
  final String productId;
  final int quantity;
  final List<String>? modifierIds;

  AddOrderItemEvent({
    required this.productId,
    required this.quantity,
    this.modifierIds,
  });
}