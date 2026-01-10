import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/data/repositories/orders_repostories.dart';
import 'package:restaurantapp/features/cart/managers/orderBLoc/orders_state.dart';
import '../../../../core/utils/status.dart';

part 'orders_event.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _orderRepository;

  OrdersBloc({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrdersState.initial()) {
    on<OrdersLoading>(_onOrdersLoading);
  }

  Future<void> _onOrdersLoading(
      OrdersLoading event,
      Emitter<OrdersState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

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
}