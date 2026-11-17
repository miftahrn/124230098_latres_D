import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.authService,
    required this.cartService,
  });

  final AuthService authService;
  final CartService cartService;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    final username = widget.authService.username;
    if (username == null) return;
    setState(() {
      _items = widget.cartService.forUser(username);
    });
  }

  Future<void> _removeItem(CartItem item) async {
    await widget.cartService.remove(
      username: item.username,
      productId: item.productId,
    );
    if (!mounted) return;
    _loadItems();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item dihapus dari cart.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: _items.isEmpty
          ? const Center(child: Text('Cart masih kosong.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  child: ListTile(
                    leading: item.thumbnail.isEmpty
                        ? const Icon(Icons.image_not_supported_outlined)
                        : Image.network(
                            item.thumbnail,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image_outlined,
                              );
                            },
                          ),
                    title: Text(item.title),
                    subtitle: Text(
                      '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      tooltip: 'Hapus',
                      onPressed: () => _removeItem(item),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
