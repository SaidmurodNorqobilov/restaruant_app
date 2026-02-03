import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/features/reservations/presentation/bloc/reservation_state.dart';
import '../../../../core/utils/status.dart';
import '../../data/repositories/reservations_repository.dart';

part 'reservation_event.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationRepository _repository;

  ReservationBloc({required ReservationRepository repository})
    : _repository = repository,
      super(ReservationState.initial()) {
    on<AddReservationEvent>(_onAddReservation);
    on<GetReservationsEvent>(_onGetReservations);
    on<UpdateReservationEvent>(_onUpdateReservation);
    on<CancelReservationEvent>(_onCancelReservation);
  }

  Future<void> _onAddReservation(
    AddReservationEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.addReservation(
      name: event.name,
      email: event.email,
      phone: event.phone,
      numberOfGuests: event.numberOfGuests,
      reservationTime: event.reservationTime,
      specialNote: event.specialNote,
      isActive: event.isActive,
    );

    result.fold(
      (error) => emit(
        state.copyWith(status: Status.error, errorMessage: error.toString()),
      ),
      (response) {
        emit(
          state.copyWith(
            status: Status.success,
            addedReservationResponse: response,
          ),
        );
        add(GetReservationsEvent());
      },
    );
  }

  Future<void> _onGetReservations(
    GetReservationsEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getReservations();

    result.fold(
      (error) => emit(
        state.copyWith(status: Status.error, errorMessage: error.toString()),
      ),
      (reservations) => emit(
        state.copyWith(status: Status.success, reservations: reservations),
      ),
    );
  }

  Future<void> _onUpdateReservation(
    UpdateReservationEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.updateReservation(
      id: event.id,
      name: event.name,
      email: event.email,
      phone: event.phone,
      numberOfGuests: event.numberOfGuests,
      reservationTime: event.reservationTime,
      specialNote: event.specialNote,
      isActive: event.isActive,
    );

    result.fold(
      (error) => emit(
        state.copyWith(status: Status.error, errorMessage: error.toString()),
      ),
      (response) {
        emit(
          state.copyWith(
            status: Status.success,
            updatedReservationResponse: response,
          ),
        );
        add(GetReservationsEvent());
      },
    );
  }

  Future<void> _onCancelReservation(
    CancelReservationEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.cancelReservation(id: event.id);
    result.fold(
      (error) => emit(
        state.copyWith(status: Status.error, errorMessage: error.toString()),
      ),
      (response) {
        emit(
          state.copyWith(
            status: Status.success,
            canceledReservationResponse: response,
          ),
        );
        add(GetReservationsEvent());
      },
    );
  }
}
