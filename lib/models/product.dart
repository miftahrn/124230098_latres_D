class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    this.brand,
    this.images = const [],
    this.tags = const [],
    this.weight = 0,
    this.dimensions = const ProductDimensions(),
    this.warrantyInformation = '',
    this.shippingInformation = '',
    this.availabilityStatus = '',
    this.reviews = const [],
    this.returnPolicy = '',
    this.minimumOrderQuantity = 1,
    this.sku = '',
    this.meta = const ProductMeta(),
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _asInt(json['id']),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: _asDouble(json['price']),
      discountPercentage: _asDouble(json['discountPercentage']),
      rating: _asDouble(json['rating']),
      stock: _asInt(json['stock']),
      thumbnail: json['thumbnail'] as String? ?? '',
      brand: json['brand'] as String?,
      images: _asStringList(json['images']),
      tags: _asStringList(json['tags']),
      weight: _asDouble(json['weight']),
      dimensions: ProductDimensions.fromJson(json['dimensions']),
      warrantyInformation: json['warrantyInformation'] as String? ?? '',
      shippingInformation: json['shippingInformation'] as String? ?? '',
      availabilityStatus: json['availabilityStatus'] as String? ?? '',
      reviews: _asReviews(json['reviews']),
      returnPolicy: json['returnPolicy'] as String? ?? '',
      minimumOrderQuantity: _asInt(json['minimumOrderQuantity'], fallback: 1),
      sku: json['sku'] as String? ?? '',
      meta: ProductMeta.fromJson(json['meta']),
    );
  }

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;
  final String? brand;
  final List<String> images;
  final List<String> tags;
  final double weight;
  final ProductDimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ProductReview> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final String sku;
  final ProductMeta meta;

  static int _asInt(dynamic value, {int fallback = 0}) =>
      (value as num?)?.toInt() ?? fallback;

  static double _asDouble(dynamic value) => (value as num?)?.toDouble() ?? 0;

  static List<String> _asStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }
    return value.whereType<String>().toList(growable: false);
  }

  static List<ProductReview> _asReviews(dynamic value) {
    if (value is! List) {
      return const [];
    }
    return value
        .whereType<Map<String, dynamic>>()
        .map(ProductReview.fromJson)
        .toList(growable: false);
  }
}

class ProductDimensions {
  const ProductDimensions({
    this.width = 0,
    this.height = 0,
    this.depth = 0,
  });

  factory ProductDimensions.fromJson(dynamic value) {
    if (value is! Map<String, dynamic>) {
      return const ProductDimensions();
    }
    return ProductDimensions(
      width: (value['width'] as num?)?.toDouble() ?? 0,
      height: (value['height'] as num?)?.toDouble() ?? 0,
      depth: (value['depth'] as num?)?.toDouble() ?? 0,
    );
  }

  final double width;
  final double height;
  final double depth;
}

class ProductReview {
  const ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      date: json['date'] as String? ?? '',
      reviewerName: json['reviewerName'] as String? ?? '',
      reviewerEmail: json['reviewerEmail'] as String? ?? '',
    );
  }

  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;
}

class ProductMeta {
  const ProductMeta({
    this.createdAt = '',
    this.updatedAt = '',
    this.barcode = '',
    this.qrCode = '',
  });

  factory ProductMeta.fromJson(dynamic value) {
    if (value is! Map<String, dynamic>) {
      return const ProductMeta();
    }
    return ProductMeta(
      createdAt: value['createdAt'] as String? ?? '',
      updatedAt: value['updatedAt'] as String? ?? '',
      barcode: value['barcode'] as String? ?? '',
      qrCode: value['qrCode'] as String? ?? '',
    );
  }

  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String qrCode;
}
