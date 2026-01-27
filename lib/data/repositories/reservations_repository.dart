import 'package:restaurantapp/core/client.dart';
import 'package:restaurantapp/core/utils/result.dart';
import '../models/reservation_model.dart';

class ReservationRepository {
  final ApiClient _client;

  ReservationRepository({required ApiClient client}) : _client = client;

  Future<Result<List<ReservationModel>>> getReservations() async {
    final response = await _client.get<List<dynamic>>(
      '/products/get_my_all_reserved_tables/',
    );

    return response.fold(
      (error) => Result.error(error),
      (data) {
        try {
          final reservations = data
              .map(
                (json) =>
                    ReservationModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
          return Result.ok(reservations);
        } catch (e) {
          return Result.error(Exception("Ma'lumotlarni o'qishda xatolik: $e"));
        }
      },
    );
  }

  Future<Result<Map<String, dynamic>>> addReservation({
    required String name,
    required String email,
    required String phone,
    required int numberOfGuests,
    required String reservationTime,
    required String specialNote,
    required bool isActive,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/products/add_bron_table/',
      data: {
        "name": name,
        "email": email,
        "phone": phone,
        "number_of_guests": numberOfGuests,
        "reservation_time": reservationTime,
        "special_note": specialNote,
        "is_active": isActive,
      },
    );
    return response;
  }

  Future<Result<Map<String, dynamic>>> updateReservation({
    required int id,
    required String name,
    required String email,
    required String phone,
    required int numberOfGuests,
    required String reservationTime,
    required String specialNote,
    required bool isActive,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/products/update_bron_table/$id/',
      data: {
        "name": name,
        "email": email,
        "phone": phone,
        "number_of_guests": numberOfGuests,
        "reservation_time": reservationTime,
        "special_note": specialNote,
        "is_active": isActive,
      },
    );
    return response;
  }

  Future<Result<Map<String, dynamic>>> cancelReservation({
    required int id,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/products/cancel_bron_table/$id/',
    );
    return response;
  }
}
