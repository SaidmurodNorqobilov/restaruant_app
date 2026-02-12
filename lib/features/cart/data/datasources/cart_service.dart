import 'package:hive/hive.dart';
import '../../../home/data/models/product_item_model.dart';

class CartService {
  static const String _boxName = 'cart_box';

  Box<ProductItemModel> get _box => Hive.box<ProductItemModel>(_boxName);

  void addToCart(ProductItemModel product, {required int quantity}) {
    final existingProduct = _box.get(product.id);

    if (existingProduct != null) {
      final updatedProduct = ProductItemModel(
        id: existingProduct.id,
        name: existingProduct.name,
        description: existingProduct.description,
        price: existingProduct.price,
        image: existingProduct.image,
        vat: existingProduct.vat,
        measureUnit: existingProduct.measureUnit,
        measure: existingProduct.measure,
        sortOrder: existingProduct.sortOrder,
        isActive: existingProduct.isActive,
        categoryId: existingProduct.categoryId,
        modifierGroups: existingProduct.modifierGroups,
        quantity: existingProduct.quantity + quantity,
        coinPrice: existingProduct.coinPrice,
      );
      _box.put(product.id, updatedProduct);
    } else {
      final newProduct = ProductItemModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        image: product.image,
        vat: product.vat,
        measureUnit: product.measureUnit,
        measure: product.measure,
        sortOrder: product.sortOrder,
        isActive: product.isActive,
        categoryId: product.categoryId,
        modifierGroups: product.modifierGroups,
        quantity: quantity,
        coinPrice: product.coinPrice,
      );
      _box.put(product.id, newProduct);
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final product = _box.get(productId);
    if (product != null) {
      final updatedProduct = ProductItemModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        image: product.image,
        vat: product.vat,
        measureUnit: product.measureUnit,
        measure: product.measure,
        sortOrder: product.sortOrder,
        isActive: product.isActive,
        categoryId: product.categoryId,
        modifierGroups: product.modifierGroups,
        quantity: newQuantity,
        coinPrice: product.coinPrice,
      );
      _box.put(productId, updatedProduct);
    }
  }

  void incrementQuantity(String productId) {
    final product = _box.get(productId);
    if (product != null) {
      updateQuantity(productId, product.quantity + 1);
    }
  }

  void decrementQuantity(String productId) {
    final product = _box.get(productId);
    if (product != null) {
      updateQuantity(productId, product.quantity - 1);
    }
  }

  List<ProductItemModel> getAllItems() {
    return _box.values.toList();
  }

  void removeFromCart(String id) {
    _box.delete(id);
  }

  void clearCart() {
    _box.clear();
  }

  double getTotalPrice() {
    return _box.values.fold(0.0, (total, item) => total + (item.price * item.quantity));
  }

  double getTotalCoins() {
    return _box.values.fold(0.0, (total, item) {
      final coinPrice = double.tryParse(item.coinPrice) ?? 0.0;
      return total + (coinPrice * item.quantity);
    });
  }

  int get cartLength => _box.length;

  int getTotalItemCount() {
    return _box.values.fold(0, (total, item) => total + item.quantity);
  }
}