import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/status.dart';
import '../../../data/repositores/location_repository.dart';
import 'location_state.dart';

part 'location_event.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  final LocationRepository _repository;

  MyLocationBloc({required LocationRepository repository})
      : _repository = repository,
        super(MyLocationState.initial()) {
    on<MyLocationLoadingEvent>(_onLoadingLocations);
    on<MyLocationRefreshEvent>(_onRefreshLocations);
    on<MyLocationDeleteEvent>(_onDeleteLocation);
    on<MyLocationEditEvent>(_onEditLocation);
    on<MyLocationAddEvent>(_onAddLocation);
  }

  Future<void> _onLoadingLocations(MyLocationLoadingEvent event,
      Emitter<MyLocationState> emit,) async {
    emit(state.copyWith(status: Status.loading));
    await _fetchLocations(emit);
  }

  Future<void> _onRefreshLocations(MyLocationRefreshEvent event,
      Emitter<MyLocationState> emit,) async {
    await _fetchLocations(emit);
  }

  Future<void> _onDeleteLocation(MyLocationDeleteEvent event,
      Emitter<MyLocationState> emit,) async {
    final result = await _repository.deleteLocation(event.locationId);

    result.fold(
          (error) {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ),
        );
      },
          (_) {
        add(MyLocationRefreshEvent());
      },
    );
  }

  Future<void> _fetchLocations(Emitter<MyLocationState> emit) async {
    final result = await _repository.getLocations();

    result.fold(
          (error) {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ),
        );
      },
          (locations) {
        emit(
          state.copyWith(
            status: Status.success,
            locations: locations,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onEditLocation(
      MyLocationEditEvent event,
      Emitter<MyLocationState> emit,
      ) async {
    final result = await _repository.updateLocation(
      id: event.locationId,
      title: event.title,
      address: event.address,
      lat: event.latitude,
      lng: event.longitude,
    );

    result.fold(
          (error) {
        emit(state.copyWith(
          status: Status.error,
          errorMessage: error.toString(),
        ));
      },
          (updatedLocation) {
        add(MyLocationRefreshEvent());
      },
    );
  }

  Future<void> _onAddLocation(
       MyLocationAddEvent event,
      Emitter<MyLocationState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _repository.addLocation(
      title: event.title,
      address: event.address,
      lat: event.latitude,
      lng: event.longitude,
    );

    result.fold(
          (error) {
        emit(state.copyWith(
          status: Status.error,
          errorMessage: error.toString(),
        ));
      },
          (value) {
        add(MyLocationRefreshEvent());
        emit(state.copyWith(status: Status.success));
      },
    );
  }

}
