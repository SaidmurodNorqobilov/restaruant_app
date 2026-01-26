import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/status.dart';
import '../../../../data/repositories/product_repository.dart';
import 'product_state.dart';

part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  ProductBloc({required ProductRepository repository})
    : _repository = repository,
      super(ProductState.initial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));
      final result = await _repository.getProducts();
      result.fold(
        (error) => emit(
          state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ),
        ),
        (products) => emit(
          state.copyWith(status: Status.success, products: products),
        ),
      );
    });

    on<AddOrderItemEvent>((event, emit) async {
      emit(
        state.copyWith(status: Status.loading),
      );
      final result = await _repository.addOrderItem(
        productId: event.productId,
        quantity: event.quantity,
      );

      result.fold(
        (error) => emit(
          state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ),
        ),
        (response) => emit(
          state.copyWith(
            status: Status.success,
            lastAddedItemResponse: response,
          ),
        ),
      );
    });
  }
}
