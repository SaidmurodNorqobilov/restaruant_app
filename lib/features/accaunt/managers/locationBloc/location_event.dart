sealed class LocationEvent {}

final class LocationLoading extends LocationEvent {
  final String address;
  final double lat;
  final double lng;

  LocationLoading({
    required this.address,
    required this.lat,
    required this.lng,
  });
}
