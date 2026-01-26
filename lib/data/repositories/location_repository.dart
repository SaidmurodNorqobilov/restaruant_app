import 'package:restaurantapp/core/client.dart';
import '../../core/utils/result.dart';

class LocationRepository {
  final ApiClient _client;

  LocationRepository({required ApiClient client}) : _client = client;

  Future<Result<Map<String, dynamic>>> addLocation({
    required int orderId,
    // required String address,
    required double lat,
    required double lng,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/products/add_order_location/',
      data: {
        "order": orderId,
        // "address": address,
        "latitude": lat,
        "longitude": lng,
      },
    );
    return response.fold(
      (error) => Result.error(error),
      (data) => Result.ok(data),
    );
  }
}
