import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../widgets/quantity_selector.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.product,
    required this.authService,
    required this.cartService,
  });

  final Product product;
  final AuthService authService;
  final CartService cartService;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _quantity = 1;
  bool _isSaving = false;

  Future<void> _addToCart() async {
    setState(() => _isSaving = true);
    try {
      await widget.cartService.addOrUpdate(
        item: CartItem(
          productId: widget.product.id,
          username: widget.authService.username!,
          title: widget.product.title,
          price: widget.product.price,
          thumbnail: widget.product.thumbnail,
          quantity: _quantity,
          stock: widget.product.stock,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan ke cart.')),
      );
    } on CartException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images.isEmpty
        ? [product.thumbnail]
        : product.images;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 240,
            child: PageView(
              children: images.where((image) => image.isNotEmpty).isEmpty
                  ? const [Icon(Icons.image_not_supported_outlined, size: 64)]
                  : images
                      .where((image) => image.isNotEmpty)
                      .map(
                        (image) => Image.network(
                          image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image_outlined,
                              size: 64,
                            );
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(product.description),
          const SizedBox(height: 16),
          _InfoRow(label: 'Harga', value: '\$${product.price}'),
          _InfoRow(label: 'Diskon', value: '${product.discountPercentage}%'),
          _InfoRow(label: 'Rating', value: product.rating.toString()),
          _InfoRow(label: 'Stok', value: product.stock.toString()),
          _InfoRow(label: 'Kategori', value: product.category),
          _InfoRow(label: 'Brand', value: product.brand ?? '-'),
          _InfoRow(label: 'SKU', value: product.sku),
          _InfoRow(label: 'Berat', value: '${product.weight}'),
          _InfoRow(
            label: 'Dimensi',
            value:
                '${product.dimensions.width} x ${product.dimensions.height} x ${product.dimensions.depth}',
          ),
          _InfoRow(
            label: 'Ketersediaan',
            value: product.availabilityStatus,
          ),
          _InfoRow(
            label: 'Pengiriman',
            value: product.shippingInformation,
          ),
          _InfoRow(
            label: 'Garansi',
            value: product.warrantyInformation,
          ),
          _InfoRow(
            label: 'Pengembalian',
            value: product.returnPolicy,
          ),
          _InfoRow(label: 'Barcode', value: product.meta.barcode),
          _InfoRow(label: 'Dibuat', value: product.meta.createdAt),
          _InfoRow(label: 'Diperbarui', value: product.meta.updatedAt),
          _InfoRow(label: 'QR Code', value: product.meta.qrCode),
          if (product.tags.isNotEmpty)
            _InfoRow(label: 'Tags', value: product.tags.join(', ')),
          if (product.reviews.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Review', style: Theme.of(context).textTheme.titleLarge),
            ...product.reviews.map(
              (review) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(review.reviewerName),
                subtitle: Text(review.comment),
                trailing: Text('${review.rating}/5'),
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (product.stock > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quantity'),
                QuantitySelector(
                  quantity: _quantity,
                  maximum: product.stock,
                  onChanged: (value) => setState(() => _quantity = value),
                ),
              ],
            ),
            FilledButton(
              onPressed: _isSaving ? null : _addToCart,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Add to Cart'),
            ),
          ] else
            const Text('Produk sedang habis.'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }
}
