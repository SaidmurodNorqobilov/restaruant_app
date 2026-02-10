import 'package:restaurantapp/core/network/client.dart';
import '../../../../core/error/result.dart';

class OrderRepository {
  final ApiClient _client;

  OrderRepository({required ApiClient client}) : _client = client;

  Future<Result<Map<String, dynamic>>> addOrders({
    required String orderType,
    required String paymentProvider,
    required String paymentMethod,
    required String address,
    required String locationId,
    required List<Map<String, dynamic>> products,
    required List<Map<String, dynamic>> modifiers,
  }) async {
    final Map<String, dynamic> orderData = {
      "order_type": orderType,
      "payment_provider": paymentProvider,
      "payment_method": paymentMethod,
      "address": address,
      "location_id": locationId,
      "products": products,
      "modifiers": modifiers,
    };

    final result = await _client.post<Map<String, dynamic>>(
      '/orders/create',
      data: orderData,
    );

    return result.fold(
          (error) => Result.error(error),
          (data) => Result.ok(data),
    );
  }
}