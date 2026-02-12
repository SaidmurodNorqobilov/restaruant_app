import 'package:restaurantapp/core/network/client.dart';
import '../../../../core/error/result.dart';
import '../models/order_model.dart';

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

  Future<Result<List<OrderModel>>> getOrders() async {
    try {
      final result = await _client.get<Map<String, dynamic>>(
        '/orders/find/my-orders',
      );
      return result.fold(
            (error) => Result.error(error),
            (data) {
          final ordersJson = data['orders'] as List<dynamic>?;

          if (ordersJson == null) {
            return Result.error(
              Exception('Orders data not found in response'),
            );
          }

          final orders = ordersJson
              .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
              .toList();

          return Result.ok(orders);
        },
      );
    } catch (e) {
      return Result.error(Exception('Failed to parse orders: $e'));
    }
  }

  Future<Result<void>> cancelOrder(String orderId) async {
    final result = await _client.delete<Map<String, dynamic>>(
      '/orders/cancel/$orderId',
    );

    return result.fold(
          (error) => Result.error(error),
          (_) => Result.ok(null),
    );
  }
}