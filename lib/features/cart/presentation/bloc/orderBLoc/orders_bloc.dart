import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/features/cart/presentation/bloc/orderBLoc/orders_state.dart';

import '../../../../../core/utils/status.dart';
import '../../../data/repositories/order_repository.dart';
part 'orders_event.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _orderRepository;

  OrdersBloc({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrdersState.initial()) {
    on<OrdersLoading>(_onOrdersLoading);
    on<AddOrderEvent>(_onAddOrder);
    on<CancelOrderEvent>(_onCancelOrder);
  }

  Future<void> _onOrdersLoading(
      OrdersLoading event,
      Emitter<OrdersState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    // If you have a getOrders method in your repository, uncomment this:
    // final result = await _orderRepository.getOrders();
    // result.fold(
    //   (error) => emit(state.copyWith(
    //     status: Status.error,
    //     errorMessage: error.toString(),
    //   )),
    //   (orders) => emit(state.copyWith(
    //     status: Status.success,
    //     orders: orders,
    //   )),
    // );

    // For now, just set success status
    emit(state.copyWith(status: Status.success));
  }

  Future<void> _onAddOrder(
      AddOrderEvent event,
      Emitter<OrdersState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final result = await _orderRepository.addOrders(
        orderType: event.orderData['order_type'] ?? '',
        paymentProvider: event.orderData['payment_provider'] ?? '',
        paymentMethod: event.orderData['payment_method'] ?? '',
        address: event.orderData['address'] ?? '',
        locationId: event.orderData['location_id'] ?? '',
        products: List<Map<String, dynamic>>.from(
          event.orderData['products'] ?? [],
        ),
        modifiers: List<Map<String, dynamic>>.from(
          event.orderData['modifiers'] ?? [],
        ),
      );

      result.fold(
            (error) {
          emit(state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ));
        },
            (data) {
          emit(state.copyWith(
            status: Status.success,
            errorMessage: null,
          ));

          // Optionally reload orders after successful submission
          // add(OrdersLoading());
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: Status.error,
        errorMessage: 'Buyurtma yuborishda xatolik: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCancelOrder(
      CancelOrderEvent event,
      Emitter<OrdersState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    // If you have a cancelOrder method in your repository, uncomment this:
    // final result = await _orderRepository.cancelOrder(event.orderId);
    // result.fold(
    //   (error) => emit(state.copyWith(
    //     status: Status.error,
    //     errorMessage: error.toString(),
    //   )),
    //   (data) {
    //     emit(state.copyWith(status: Status.success));
    //     add(OrdersLoading());
    //   },
    // );

    // For now, just set success status
    emit(state.copyWith(status: Status.success));
  }
}