part of 'location_bloc.dart';

sealed class MyLocationEvent {}

final class MyLocationLoadingEvent extends MyLocationEvent {}

final class MyLocationRefreshEvent extends MyLocationEvent {}

final class MyLocationDeleteEvent extends MyLocationEvent {
  final String locationId;

  MyLocationDeleteEvent({required this.locationId});
}

final class MyLocationEditEvent extends MyLocationEvent {
  final String locationId;
  final String title;
  final String address;
  final double latitude;
  final double longitude;

  MyLocationEditEvent({
    required this.locationId,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

final class MyLocationAddEvent extends MyLocationEvent {
  final String title;
  final String address;
  final double latitude;
  final double longitude;

  MyLocationAddEvent({
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}
