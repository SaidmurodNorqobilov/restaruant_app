import 'package:restaurantapp/features/cart/data/datasources/cart_service.dart';
import 'package:restaurantapp/features/home/data/models/product_item_model.dart';

class OrderService {
  final CartService _cartService = CartService();

  Map<String, dynamic> prepareOrderData({
    required String orderType, // 'delivery', 'eat_in', 'take_away'
    required String paymentProvider, // 'cash', 'card', 'online'
    required String paymentMethod, // 'cash', 'card', 'online'
    required String address,
    required String locationId,
  }) {
    final cartItems = _cartService.getAllItems();

    if (cartItems.isEmpty) {
      throw Exception('Savat bo\'sh. Buyurtma berishdan oldin mahsulot qo\'shing.');
    }
    final List<Map<String, dynamic>> products = cartItems.map((item) {
      return {
        'product_id': item.id,
        'quantity': item.quantity,
        'price': item.price,
      };
    }).toList();
    final List<Map<String, dynamic>> modifiers = [];

    for (var item in cartItems) {
      for (var modifierGroup in item.modifierGroups) {
        for (var modifier in modifierGroup.modifiers) {
          modifiers.add({
            'modifier_id': modifier.id,
            'product_id': item.id,
            'quantity': item.quantity,
            'price': modifier.price,
          });
        }
      }
    }

    return {
      'order_type': orderType,
      'payment_provider': paymentProvider,
      'payment_method': paymentMethod,
      'address': address,
      'location_id': locationId,
      'products': products,
      'modifiers': modifiers,
    };
  }

  Map<String, double> calculateOrderTotals() {
    final cartItems = _cartService.getAllItems();

    double subtotal = 0.0;
    double modifiersTotal = 0.0;

    for (var item in cartItems) {
      subtotal += item.price * item.quantity;
      for (var group in item.modifierGroups) {
        for (var modifier in group.modifiers) {
          modifiersTotal += modifier.price * item.quantity;
        }
      }
    }

    final double productTotal = subtotal + modifiersTotal;
    final double vat = productTotal * 0.05; // 5% VAT
    final double total = productTotal + vat;

    return {
      'subtotal': subtotal,
      'modifiers_total': modifiersTotal,
      'product_total': productTotal,
      'vat': vat,
      'total': total,
    };
  }

  String getCartSummary() {
    final cartItems = _cartService.getAllItems();
    final totals = calculateOrderTotals();

    StringBuffer summary = StringBuffer();
    summary.writeln('Buyurtma tafsilotlari:');
    summary.writeln('-------------------');

    for (var item in cartItems) {
      summary.writeln('${item.name} x${item.quantity}');
      if (item.modifierGroups.isNotEmpty) {
        for (var group in item.modifierGroups) {
          if (group.modifiers.isNotEmpty) {
            summary.writeln('  Qo\'shimchalar:');
            for (var modifier in group.modifiers) {
              summary.writeln('    - ${modifier.name} (+${modifier.price.toStringAsFixed(2)} SO\'M)');
            }
          }
        }
      }
    }

    summary.writeln('-------------------');
    summary.writeln('Oraliq summa: ${totals['subtotal']!.toStringAsFixed(2)} SO\'M');
    if (totals['modifiers_total']! > 0) {
      summary.writeln('Qo\'shimchalar: ${totals['modifiers_total']!.toStringAsFixed(2)} SO\'M');
    }
    summary.writeln('QQS (5%): ${totals['vat']!.toStringAsFixed(2)} SO\'M');
    summary.writeln('Jami: ${totals['total']!.toStringAsFixed(2)} SO\'M');

    return summary.toString();
  }

  bool validateOrder({
    required String orderType,
    required String locationId,
    required String address,
  }) {
    final cartItems = _cartService.getAllItems();

    if (cartItems.isEmpty) {
      return false;
    }

    if (orderType == 'delivery' && (locationId.isEmpty || address.isEmpty)) {
      return false;
    }

    for (var item in cartItems) {
      if (!item.isActive) {
        return false;
      }
    }
    return true;
  }
  void clearCartAfterOrder() {
    _cartService.clearCart();
  }
}