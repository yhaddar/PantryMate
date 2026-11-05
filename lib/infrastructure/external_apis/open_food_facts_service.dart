import 'dart:convert';

import 'package:http/http.dart' as http;

enum ProductLookupFailure {
  notFound,
  network,
  rateLimited,
  server,
  invalidResponse,
}

class ProductLookupException implements Exception {
  const ProductLookupException(this.kind, this.message);

  final ProductLookupFailure kind;
  final String message;
}

class ExternalProductMetadata {
  const ExternalProductMetadata({
    required this.barcode,
    this.name,
    this.brand,
    this.imageUrl,
  });

  final String barcode;
  final String? name;
  final String? brand;
  final String? imageUrl;
}

class OpenFoodFactsService {
  OpenFoodFactsService({
    http.Client? client,
    this.userAgent = 'PantryMate/1.0 (contact unavailable)',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String userAgent;

  Future<ExternalProductMetadata> lookup(String barcode) async {
    final normalized = barcode.replaceAll(RegExp(r'[^0-9]'), '');
    if (normalized.isEmpty) {
      throw const ProductLookupException(
        ProductLookupFailure.invalidResponse,
        'Barcode is empty.',
      );
    }
    final uri = Uri.https(
      'world.openfoodfacts.org',
      '/api/v3/product/$normalized',
      {'fields': 'code,product_name,brands,image_front_url'},
    );
    http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: {'User-Agent': userAgent, 'Accept': 'application/json'},
      );
    } catch (_) {
      throw const ProductLookupException(
        ProductLookupFailure.network,
        'Open Food Facts is unavailable.',
      );
    }
    if (response.statusCode == 404) {
      throw const ProductLookupException(
        ProductLookupFailure.notFound,
        'Product was not found.',
      );
    }
    if (response.statusCode == 429) {
      throw const ProductLookupException(
        ProductLookupFailure.rateLimited,
        'Product lookup is rate limited.',
      );
    }
    if (response.statusCode >= 500) {
      throw const ProductLookupException(
        ProductLookupFailure.server,
        'Open Food Facts returned a server error.',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const ProductLookupException(
        ProductLookupFailure.invalidResponse,
        'Open Food Facts returned an invalid response.',
      );
    }
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final product = body['product'] as Map<String, dynamic>?;
      if (product == null || body['status'] == 0) {
        throw const ProductLookupException(
          ProductLookupFailure.notFound,
          'Product was not found.',
        );
      }
      return ExternalProductMetadata(
        barcode: normalized,
        name: product['product_name'] as String?,
        brand: product['brands'] as String?,
        imageUrl: product['image_front_url'] as String?,
      );
    } on ProductLookupException {
      rethrow;
    } catch (_) {
      throw const ProductLookupException(
        ProductLookupFailure.invalidResponse,
        'Product response could not be parsed.',
      );
    }
  }
}
