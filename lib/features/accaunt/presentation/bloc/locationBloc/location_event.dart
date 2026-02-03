sealed class LocationEvent {}

final class LocationLoading extends LocationEvent {
  // final String address;
  final int orderId;
  final double lat;
  final double lng;

  LocationLoading({
    required this.orderId,
    // required this.address,
    required this.lat,
    required this.lng,
  });
}
