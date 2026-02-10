import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/utils/status.dart';
import '../../../data/models/location_model.dart';
part 'location_state.freezed.dart';

@freezed
class MyLocationState with _$MyLocationState {
  const factory MyLocationState({
    required List<LocationModel> locations,
    required Status status,
    required Map<String, dynamic> editLocation,
    required Map<String, dynamic> addLocations,
    String? errorMessage,
  }) = _MyLocationState;

  factory MyLocationState.initial() => const MyLocationState(
    locations: [],
    status: Status.initial,
    errorMessage: null,
    editLocation: {},
    addLocations: {},
  );
}