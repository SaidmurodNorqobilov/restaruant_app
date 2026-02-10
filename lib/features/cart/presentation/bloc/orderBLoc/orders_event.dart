part of 'orders_bloc.dart';

sealed class OrdersEvent {}

final class OrdersLoading extends OrdersEvent {}

final class CancelOrderEvent extends OrdersEvent {
  final int orderId;
  CancelOrderEvent({required this.orderId});
}

final class AddOrderEvent extends OrdersEvent {
  final Map<String, dynamic> orderData;

  AddOrderEvent({required this.orderData});
}