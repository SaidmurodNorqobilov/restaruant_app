import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/core/utils/status.dart';

import '../../../data/repositores/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _repository;

  LocationBloc({required LocationRepository repository})
      : _repository = repository,
        super(LocationState.initial()) {
    on<LocationLoading>(_onLocationLoading);
    // on<SaveLocationEvent>(_onSaveLocation);
  }

  Future<void> _onLocationLoading(
      LocationLoading event,
      Emitter<LocationState> emit,
      ) async {
    emit(state.copyWith(
      lat: event.lat,
      lng: event.lng,
      // address: event.address,
      orderId: event.orderId,
    ));
  }

  Future<void> _onSaveLocation(
      // SaveLocationEvent event,
      Emitter<LocationState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _repository.addLocation(
      orderId: state.orderId,
      // address: state.address,
      lat: state.lat,
      lng: state.lng,
    );

    result.fold(
          (error) => emit(state.copyWith(
        status: Status.error,
        errorMessage: error.toString(),
      )),
          (response) => emit(state.copyWith(
        status: Status.success,
      )),
    );
  }
}