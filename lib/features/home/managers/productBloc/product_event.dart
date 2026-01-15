part of 'product_bloc.dart';

abstract class ProductEvent {}

class GetProductsEvent extends ProductEvent {}

class AddOrderItemEvent extends ProductEvent {
  final int productId;
  final int quantity;
  final int orderId;

  AddOrderItemEvent({
    required this.productId,
    required this.quantity,
    required this.orderId,
  });
}