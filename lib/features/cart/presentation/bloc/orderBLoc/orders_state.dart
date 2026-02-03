import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/utils/status.dart';
import '../../../data/models/orders_model.dart';
part 'orders_state.freezed.dart';

@freezed
class OrdersState with _$OrdersState {
  const factory OrdersState({
    required Status status,
    required List<OrderModel> orders,
    Map<String, dynamic>? cancelOrder,
    String? errorMessage,
  }) = _OrdersState;

  factory OrdersState.initial() => const OrdersState(
    status: Status.initial,
    orders: [],
    cancelOrder: null,
    errorMessage: null,
  );
}