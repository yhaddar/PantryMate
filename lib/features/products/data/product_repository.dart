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
