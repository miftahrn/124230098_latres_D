import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/product.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri get productsUri =>
      Uri.parse('${AppConfig.apiBaseUrl}${AppConfig.productsPath}');

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client.get(productsUri);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Server mengembalikan status ${response.statusCode}.');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic> || decoded['products'] is! List) {
        throw const ApiException('Format data produk tidak valid.');
      }

      return (decoded['products'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList(growable: false);
    } on http.ClientException {
      throw const ApiException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet.',
      );
    } on FormatException {
      throw const ApiException('Response server tidak dapat dibaca.');
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
