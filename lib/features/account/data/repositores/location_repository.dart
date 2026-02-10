import '../../../../core/error/result.dart';
import '../../../../core/network/client.dart';
import '../models/location_model.dart';

class LocationRepository {
  final ApiClient _client;

  LocationRepository({required ApiClient client}) : _client = client;

  Future<Result<LocationModel>> addLocation({
    required String title,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/locations',
      data: {
        "title": title,
        "address_line": address,
        "latitude": lat,
        "longitude": lng,
      },
    );

    return response.fold(
      (error) => Result.error(error),
      (data) => Result.ok(LocationModel.fromJson(data)),
    );
  }

  Future<Result<List<LocationModel>>> getLocations() async {
    try {
      final response = await _client.get<List<dynamic>>('/locations/my');
      return response.fold(
        (error) => Result.error(error),
        (data) {
          if (data.isEmpty) {
            return Result.ok([]);
          }
          return Result.ok(
            data
                .map(
                  (e) => LocationModel.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          );
        },
      );
    } catch (e) {
      return Result.error(
        Exception(e.toString()),
      );
    }
  }

  Future<Result<void>> deleteLocation(String id) async {
    final response = await _client.delete<void>('/locations/delete/$id');
    return response.fold(
      (error) => Result.error(error),
      (data) => Result.ok(data),
    );
  }

  Future<Result<LocationModel>> updateLocation({
    required String id,
    required String title,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/locations/update/$id',
      data: {
        "title": title,
        "address_line": address,
        "latitude": lat,
        "longitude": lng,
      },
    );

    return response.fold(
      (error) => Result.error(error),
      (data) => Result.ok(LocationModel.fromJson(data)),
    );
  }
}
