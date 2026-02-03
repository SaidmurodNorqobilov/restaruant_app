import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/status.dart';
import '../../data/models/reservation_model.dart';

part 'reservation_state.freezed.dart';

@freezed
class ReservationState with _$ReservationState {
  const factory ReservationState({
    required Status status,
    String? errorMessage,
    Map<String, dynamic>? addedReservationResponse,
    List<ReservationModel>? reservations,
    Map<String, dynamic>? updatedReservationResponse,
    Map<String, dynamic>? canceledReservationResponse,
  }) = _ReservationState;

  factory ReservationState.initial() => const ReservationState(
    status: Status.initial,
    errorMessage: null,
    addedReservationResponse: null,
    reservations: [],
    updatedReservationResponse: null,
    canceledReservationResponse: null,
  );
}
