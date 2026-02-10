import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/utils/status.dart';
import '../../../data/models/delivery_model.dart';
part 'delivery_state.freezed.dart';

@freezed
class DeliveryState with _$DeliveryState {
  const factory DeliveryState({
    required Status status,
    String? errorMessage,
    required List<DeliveryModel> deliveries,
  }) = _DeliveryState;

  factory DeliveryState.initial() => const DeliveryState(
    status: Status.initial,
    errorMessage: null,
    deliveries: [],
  );
}