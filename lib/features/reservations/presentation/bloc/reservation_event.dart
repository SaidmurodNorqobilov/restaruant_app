part of 'reservation_bloc.dart';

abstract class ReservationEvent {}

class AddReservationEvent extends ReservationEvent {
  final String name;
  final String email;
  final String phone;
  final int numberOfGuests;
  final String reservationTime;
  final String specialNote;
  final bool isActive;

  AddReservationEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.numberOfGuests,
    required this.reservationTime,
    required this.specialNote,
    required this.isActive,
  });
}

class GetReservationsEvent extends ReservationEvent {}

class UpdateReservationEvent extends ReservationEvent {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int numberOfGuests;
  final String reservationTime;
  final String specialNote;
  final bool isActive;

  UpdateReservationEvent({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.numberOfGuests,
    required this.reservationTime,
    required this.specialNote,
    required this.isActive,
  });
}

class CancelReservationEvent extends ReservationEvent {
  final int id;

  CancelReservationEvent({required this.id});
}
