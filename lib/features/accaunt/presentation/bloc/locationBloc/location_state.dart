import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/utils/status.dart';
part 'location_state.freezed.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState({
    required int orderId,
    required double lat,
    required double lng,
    // required String address,
    required Status status,
    String? errorMessage,
  }) = _LocationState;

  factory LocationState.initial() => const LocationState(
    orderId: 1,
    lat: 0.0,
    lng: 0.0,
    // address: '',
    status: Status.initial,
    errorMessage: null,
  );
}