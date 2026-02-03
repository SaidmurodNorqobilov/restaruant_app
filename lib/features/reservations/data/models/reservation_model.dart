class ReservationModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int numberOfGuests;
  final String reservationTime;
  final String specialNote;
  final bool isActive;

  ReservationModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.numberOfGuests,
    required this.reservationTime,
    required this.specialNote,
    required this.isActive,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      numberOfGuests: json['number_of_guests'] ?? 0,
      reservationTime: json['reservation_time'] ?? '',
      specialNote: json['special_note'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }
}