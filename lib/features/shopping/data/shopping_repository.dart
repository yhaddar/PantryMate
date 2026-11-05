import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/shopping_models.dart';

class ShoppingRepository {
  const ShoppingRepository(this._client);

  final SupabaseClient _client;

  Future<List<ShoppingList>> lists(String householdId) async {
    final rows = await _client
        .from('shopping_lists')
        .select()
        .eq('household_id', householdId)
        .isFilter('archived_at', null)
        .order('name');
    return rows
        .map(
          (row) => ShoppingList(
            id: row['id'] as String,
            householdId: row['household_id'] as String,
            name: row['name'] as String,
            isDefault: row['is_default'] as bool,
          ),
        )
        .toList();
  }

  Future<ShoppingList> createList({
    required String householdId,
    required String name,
  }) async {
    final row = await _client
        .from('shopping_lists')
        .insert({'household_id': householdId, 'name': name})
        .select()
        .single();
    return ShoppingList(
      id: row['id'] as String,
      householdId: row['household_id'] as String,
      name: row['name'] as String,
      isDefault: row['is_default'] as bool,
    );
  }

  Future<List<ShoppingItem>> items(String listId) async {
    final rows = await _client
        .from('shopping_list_items')
        .select()
        .eq('list_id', listId)
        .isFilter('removed_at', null)
        .order('created_at');
    return rows
        .map(
          (row) => ShoppingItem(
            id: row['id'] as String,
            listId: row['list_id'] as String,
            name: row['name'] as String,
            quantity: row['quantity'] as num,
            unit: row['unit'] as String,
            priority: row['priority'] as String,
            purchasedAt: row['purchased_at'] == null
                ? null
                : DateTime.parse(row['purchased_at'] as String),
          ),
        )
        .toList();
  }

  Future<ShoppingItem> addItem({
    required String householdId,
    required String listId,
    required String name,
    required num quantity,
    required String unit,
    String priority = 'normal',
  }) async {
    final row = await _client
        .from('shopping_list_items')
        .insert({
          'household_id': householdId,
          'list_id': listId,
          'name': name,
          'quantity': quantity,
          'unit': unit,
          'priority': priority,
        })
        .select()
        .single();
    return ShoppingItem(
      id: row['id'] as String,
      listId: row['list_id'] as String,
      name: row['name'] as String,
      quantity: row['quantity'] as num,
      unit: row['unit'] as String,
      priority: row['priority'] as String,
    );
  }
}
