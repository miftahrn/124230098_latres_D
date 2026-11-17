import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:latres/models/cart_item.dart';
import 'package:latres/services/cart_service.dart';

void main() {
  late Directory hiveDirectory;
  late Box<CartItem> box;
  late CartService service;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('latres_cart_test_');
    Hive.init(hiveDirectory.path);
    Hive.registerAdapter(CartItemAdapter());
    box = await Hive.openBox<CartItem>('cart_service_test');
    service = CartService(box: box);
  });

  setUp(() async {
    await box.clear();
  });

  tearDownAll(() async {
    await box.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('keeps cart items isolated by username', () async {
    await service.addOrUpdate(item: _item(username: 'user-a', productId: 1));
    await service.addOrUpdate(item: _item(username: 'user-b', productId: 2));

    expect(service.forUser('user-a').map((item) => item.productId), [1]);
    expect(service.forUser('user-b').map((item) => item.productId), [2]);
  });

  test('recreates the requested user A/B login scenario', () async {
    await service.addOrUpdate(item: _item(username: 'user-a', productId: 1));
    await service.addOrUpdate(item: _item(username: 'user-a', productId: 2));
    await service.addOrUpdate(item: _item(username: 'user-b', productId: 3));

    expect(
      service.forUser('user-a').map((item) => item.productId).toList(),
      [1, 2],
    );
    expect(
      service.forUser('user-b').map((item) => item.productId).toList(),
      [3],
    );
  });

  test('updates an existing product and rejects quantity over stock', () async {
    await service.addOrUpdate(
      item: _item(username: 'user-a', productId: 1, quantity: 2, stock: 3),
    );
    await service.addOrUpdate(
      item: _item(username: 'user-a', productId: 1, quantity: 1, stock: 3),
    );

    expect(service.forUser('user-a').single.quantity, 3);
    expect(
      service.addOrUpdate(
        item: _item(username: 'user-a', productId: 1, quantity: 1, stock: 3),
      ),
      throwsA(isA<CartException>()),
    );
  });

  test('removes only the requested item', () async {
    await service.addOrUpdate(item: _item(username: 'user-a', productId: 1));
    await service.addOrUpdate(item: _item(username: 'user-a', productId: 2));

    await service.remove(username: 'user-a', productId: 1);

    expect(service.forUser('user-a').map((item) => item.productId), [2]);
  });
}

CartItem _item({
  required String username,
  required int productId,
  int quantity = 1,
  int stock = 10,
}) {
  return CartItem(
    productId: productId,
    username: username,
    title: 'Product $productId',
    price: 10,
    thumbnail: '',
    quantity: quantity,
    stock: stock,
  );
}
