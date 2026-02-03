import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/status.dart';
import '../../../data/repositories/cart_repository.dart';
import 'cart_state.dart';

part 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;

  CartBloc({required CartRepository repository})
      : _repository = repository,
        super(CartState.initial()) {
    on<CartLoading>(_onCartLoading);
    on<CartUpdate>(_onCartUpdate);
    on<DeleteCartItem>((event, emit) {
      print("Mahsulot o'chirilmoqda: ${event.itemId}");
    });
  }

  Future<void> _onCartLoading(CartLoading event,
      Emitter<CartState> emit,) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _repository.getCart();

    result.fold(
          (error) =>
          emit(
            state.copyWith(
                status: Status.error, errorMessage: error.toString()),
          ),
          (items) =>
          emit(
            state.copyWith(
              status: Status.success,
              cart: items,
            ),
          ),
    );
  }

  Future<void> _onCartUpdate(CartUpdate event,
      Emitter<CartState> emit,) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _repository.updateCartItem(
      itemId: event.itemId,
      quantity: event.quantity,
    );

    result.fold(
          (error) =>
          emit(
            state.copyWith(
                status: Status.error, errorMessage: error.toString()),
          ),
          (response) {
        emit(
          state.copyWith(
            status: Status.success,
            updatedCartResponse: response,
          ),
        );
        add(CartLoading());
      },
    );
  }

  Future<void> deleteCartItem(int itemId) async {
    emit(
      state.copyWith(status: Status.loading),
    );
    final result = await _repository.deleteCartItem(itemId);
    result.fold(
          (error) =>
          emit(
            state.copyWith(
              status: Status.error,
              errorMessage: error.toString(),
            ),
          ),
          (_) =>
          emit(
            state.copyWith(
              status: Status.success,
              cart: state.cart?.where((item) => item.id != itemId).toList(),
            ),
          ),
    );
  }
}