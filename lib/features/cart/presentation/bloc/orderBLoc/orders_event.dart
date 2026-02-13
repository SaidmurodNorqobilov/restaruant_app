part of 'orders_bloc.dart';

sealed class OrdersEvent {}

final class OrdersLoading extends OrdersEvent {}

final class CancelOrderEvent extends OrdersEvent {
  final String orderId;
  CancelOrderEvent({required this.orderId});
}

final class AddOrderEvent extends OrdersEvent {
  final Map<String, dynamic> orderData;

  AddOrderEvent({required this.orderData});
}

final class RetryPaymentEvent extends OrdersEvent {
  final String orderId;
  final String paymentProvider;
  final String paymentMethod;

  RetryPaymentEvent({
    required this.orderId,
    required this.paymentProvider,
    required this.paymentMethod,
  });
}