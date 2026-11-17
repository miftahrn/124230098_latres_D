import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:latres/models/product.dart';
import 'package:latres/services/api_service.dart';

void main() {
  test('parses products from the API response', () async {
    final service = ApiService(
      client: _FakeClient(
        statusCode: 200,
        body: jsonEncode({
          'products': [
            {
              'id': 1,
              'title': 'Phone',
              'description': 'A phone',
              'category': 'smartphones',
              'price': 100,
              'discountPercentage': 5,
              'rating': 4.5,
              'stock': 10,
              'thumbnail': 'https://example.com/phone.png',
            },
          ],
        }),
      ),
    );

    final products = await service.fetchProducts();

    expect(products, hasLength(1));
    expect(products.single, isA<Product>());
    expect(products.single.title, 'Phone');
  });

  test('throws ApiException for a failed response', () async {
    final service = ApiService(
      client: _FakeClient(statusCode: 500, body: 'server error'),
    );

    expect(
      service.fetchProducts(),
      throwsA(isA<ApiException>()),
    );
  });
}

class _FakeClient extends http.BaseClient {
  _FakeClient({required this.statusCode, required this.body});

  final int statusCode;
  final String body;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      statusCode,
    );
  }
}
