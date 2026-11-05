import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/product_models.dart';

class ProductRepository {
  const ProductRepository(this._client);

  final SupabaseClient _client;

  Future<List<Product>> list(String householdId) async {
    final rows = await _client
        .from('products')
        .select()
        .eq('household_id', householdId)
        .isFilter('archived_at', null)
        .order('name');
    return rows.map(_fromRow).toList();
  }

  Future<Product> create(Product product) async {
    final row = await _client
        .from('products')
        .insert({
          'id': product.id,
          'household_id': product.householdId,
          'name': product.name,
          'category_id': product.categoryId,
          'base_unit': product.baseUnit,
          'barcode': product.barcode,
          'brand': product.brand,
          'notes': product.notes,
        })
        .select()
        .single();
    return _fromRow(row);
  }

  Future<void> setImagePath({
    required String productId,
    required String imagePath,
  }) async {
    await _client
        .from('products')
        .update({'image_path': imagePath})
        .eq('id', productId);
  }

  Future<Set<String>> listFavoriteProductIds(String householdId) async {
    final rows = await _client
        .from('favorite_products')
        .select('product_id')
        .eq('household_id', householdId);
    return rows.map((row) => row['product_id'] as String).toSet();
  }

  Future<void> setFavorite({
    required String householdId,
    required String productId,
    required bool favorite,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthException('Authentication required');
    if (favorite) {
      await _client.from('favorite_products').upsert({
        'user_id': userId,
        'household_id': householdId,
        'product_id': productId,
      });
    } else {
      await _client
          .from('favorite_products')
          .delete()
          .eq('user_id', userId)
          .eq('household_id', householdId)
          .eq('product_id', productId);
    }
  }

  Future<List<String>> listRecentlyUsedProductIds(String householdId) async {
    final rows = await _client
        .from('recent_product_usage')
        .select('product_id')
        .eq('household_id', householdId)
        .order('last_used_at', ascending: false)
        .limit(8);
    return rows.map((row) => row['product_id'] as String).toList();
  }

  Future<void> recordRecentlyUsed({
    required String householdId,
    required String productId,
  }) async {
    await _client.rpc(
      'record_recent_product',
      params: {'p_household_id': householdId, 'p_product_id': productId},
    );
  }

  Product _fromRow(Map<String, dynamic> row) => Product(
    id: row['id'] as String,
    householdId: row['household_id'] as String,
    name: row['name'] as String,
    categoryId: row['category_id'] as String,
    baseUnit: row['base_unit'] as String,
    barcode: row['barcode'] as String?,
    brand: row['brand'] as String?,
    notes: row['notes'] as String?,
    archived: row['archived_at'] != null,
  );
}
