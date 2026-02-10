import 'package:restaurantapp/core/network/client.dart';
import '../../../../core/error/result.dart';
import '../models/delivery_model.dart';

class DeliveryRepository {
  final ApiClient _apiClient;

  DeliveryRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Result<DeliveryModel>> fetchDeliveries() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      '/delivery-settings',
    );

    return result.fold(
          (error) => Result.error(error),
          (data) {
        try {
          final delivery = DeliveryModel.fromJson(data);
          return Result.ok(delivery);
        } catch (e) {
          return Result.error(
            Exception("Delivery ma'lumotlarini o'qishda xatolik"),
          );
        }
      },
    );
  }
}