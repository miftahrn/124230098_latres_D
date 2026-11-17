import 'package:hive/hive.dart';

import '../config/app_config.dart';
import '../models/cart_item.dart';

class CartService {
  CartService({Box<CartItem>? box})
      : _box = box ?? Hive.box<CartItem>(AppConfig.cartBoxName);

  final Box<CartItem> _box;

  List<CartItem> forUser(String username) {
    return _box.values
        .where((item) => item.username == username)
        .toList(growable: false);
  }

  Future<void> addOrUpdate({
    required CartItem item,
  }) async {
    final key = _keyFor(item.username, item.productId);
    final existing = _box.get(key);
    final quantity = (existing?.quantity ?? 0) + item.quantity;
    if (quantity > item.stock || quantity < 1) {
      throw const CartException('Quantity melebihi stock produk.');
    }

    await _box.put(
      key,
      CartItem(
        productId: item.productId,
        username: item.username,
        title: item.title,
        price: item.price,
        thumbnail: item.thumbnail,
        quantity: quantity,
        stock: item.stock,
      ),
    );
  }

  Future<void> remove({
    required String username,
    required int productId,
  }) {
    return _box.delete(_keyFor(username, productId));
  }

  static String _keyFor(String username, int productId) =>
      '$username::$productId';
}

class CartException implements Exception {
  const CartException(this.message);

  final String message;

  @override
  String toString() => message;
}
