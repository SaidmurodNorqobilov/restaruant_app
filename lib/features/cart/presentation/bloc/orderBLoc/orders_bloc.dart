import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/features/cart/data/repositories/orders_repostories.dart';
import '../../../../../core/utils/status.dart';
import 'orders_state.dart';

part 'orders_event.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _orderRepository;

  OrdersBloc({required OrderRepository orderRepository})
    : _orderRepository = orderRepository,
      super(OrdersState.initial()) {
    on<OrdersLoading>(_onOrdersLoading);
    on<CancelOrderEvent>(_onCancelOrder);
  }

  Future<void> _onOrdersLoading(
    OrdersLoading event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(status: Status.loading),
    );

    final result = await _orderRepository.getOrders();

    result.fold(
      (error) => emit(
        state.copyWith(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      ),
      (orders) => emit(
        state.copyWith(
          status: Status.success,
          orders: orders,
        ),
      ),
    );
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _orderRepository.cancelOrder(event.orderId);

    await result.fold(
      (error) async {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ),
        );
      },
      (data) async {
        add(OrdersLoading());
      },
    );
  }
}