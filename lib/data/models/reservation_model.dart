class ReservationModel {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final int numberOfGuests;
  final String reservationTime;
  final String specialNote;
  final bool isActive;

  ReservationModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.numberOfGuests,
    required this.reservationTime,
    required this.specialNote,
    required this.isActive,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone'],
      numberOfGuests: json['number_of_guests'],
      reservationTime: json['reservation_time'],
      specialNote: json['special_note'],
      isActive: json['is_active'],
    );
  }
}
