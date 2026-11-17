import 'package:hive/hive.dart';

class CartItem {
  const CartItem({
    required this.productId,
    required this.username,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
    required this.stock,
  });

  final int productId;
  final String username;
  final String title;
  final double price;
  final String thumbnail;
  final int quantity;
  final int stock;
}

class CartItemAdapter extends TypeAdapter<CartItem> {
  static const int adapterTypeId = 0;

  @override
  int get typeId => CartItemAdapter.adapterTypeId;

  @override
  CartItem read(BinaryReader reader) {
    final fields = <int, dynamic>{
      for (var index = 0; index < reader.readByte(); index++)
        reader.readByte(): reader.read(),
    };
    return CartItem(
      productId: fields[0] as int,
      username: fields[1] as String,
      title: fields[2] as String,
      price: fields[3] as double,
      thumbnail: fields[4] as String,
      quantity: fields[5] as int,
      stock: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItem object) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(object.productId)
      ..writeByte(1)
      ..write(object.username)
      ..writeByte(2)
      ..write(object.title)
      ..writeByte(3)
      ..write(object.price)
      ..writeByte(4)
      ..write(object.thumbnail)
      ..writeByte(5)
      ..write(object.quantity)
      ..writeByte(6)
      ..write(object.stock);
  }
}
