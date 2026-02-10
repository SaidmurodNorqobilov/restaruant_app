import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/status.dart';
import '../../../data/repositories/delivery_repository.dart';
import 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  final DeliveryRepository _deliveryRepository;

  DeliveryCubit({required DeliveryRepository deliveryRepository})
      : _deliveryRepository = deliveryRepository,
        super(DeliveryState.initial());

  Future<void> fetchDeliveries() async {
    emit(state.copyWith(status: Status.loading));

    final result = await _deliveryRepository.fetchDeliveries();

    result.fold(
          (error) => emit(state.copyWith(
        status: Status.error,
        errorMessage: error.toString(),
      )),
          (delivery) => emit(state.copyWith(
        status: Status.success,
        deliveries: [delivery],
      )),
    );
  }
}