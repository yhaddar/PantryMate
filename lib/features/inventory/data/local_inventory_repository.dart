import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../infrastructure/database/local/app_database.dart';

class LocalInventoryRepository {
  LocalInventoryRepository(this._database, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _database;
  final Uuid _uuid;

  Future<void> importBatches({
    required String userId,
    required String householdId,
    required List<Map<String, String>> rows,
  }) async {
    if (rows.isEmpty) throw ArgumentError('Import contains no rows.');
    final products = await _database.productsForHousehold(householdId);
    final byName = {
      for (final product in products)
        product.name.trim().toLowerCase(): product,
    };
    final prepared =
        <
          ({
            String batchId,
            String operationId,
            String productId,
            double quantity,
            String unit,
            String locationId,
            DateTime? expiresOn,
          })
        >[];
    for (final row in rows) {
      final product = byName[row['product']!.trim().toLowerCase()];
      final quantity = num.tryParse(row['quantity']!);
      final expiryText = row['expires_on']!.trim();
      final expiresOn = expiryText.isEmpty
          ? null
          : DateTime.tryParse(expiryText);
      if (product == null ||
          quantity == null ||
          quantity <= 0 ||
          row['unit']!.trim().isEmpty ||
          row['location']!.trim().isEmpty ||
          (expiryText.isNotEmpty && expiresOn == null)) {
        throw ArgumentError('Import contains invalid or unknown product data.');
      }
      prepared.add((
        batchId: _uuid.v4(),
        operationId: _uuid.v4(),
        productId: product.id,
        quantity: quantity.toDouble(),
        unit: row['unit']!.trim(),
        locationId: row['location']!.trim(),
        expiresOn: expiresOn,
      ));
    }
    final now = DateTime.now().toUtc();
    await _database.transaction(() async {
      for (final item in prepared) {
        await _database
            .into(_database.inventoryBatches)
            .insert(
              InventoryBatchesCompanion.insert(
                id: item.batchId,
                householdId: householdId,
                productId: item.productId,
                quantity: item.quantity,
                unit: item.unit,
                locationId: item.locationId,
                expiresOn: Value(item.expiresOn),
                createdAt: now,
                updatedAt: now,
              ),
            );
        await _database
            .into(_database.outboxOperations)
            .insert(
              OutboxOperationsCompanion.insert(
                operationId: item.operationId,
                userId: userId,
                householdId: householdId,
                entityType: 'inventory_batch',
                entityId: item.batchId,
                operationType: 'create',
                payload: jsonEncode({
                  'batch_id': item.batchId,
                  'product_id': item.productId,
                  'quantity': item.quantity,
                  'unit': item.unit,
                  'location_id': item.locationId,
                  'expires_on': item.expiresOn?.toIso8601String(),
                }),
                createdAt: now,
              ),
            );
      }
    });
  }

  Stream<List<InventoryBatche>> watchBatches(String householdId) {
    return (_database.select(_database.inventoryBatches)
          ..where(
            (row) =>
                row.householdId.equals(householdId) &
                row.archived.equals(false),
          )
          ..orderBy([
            (row) => OrderingTerm(
              expression: row.updatedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  Future<void> addBatch({
    required String userId,
    required String householdId,
    required String productId,
    required num quantity,
    required String unit,
    required String locationId,
    DateTime? expiresOn,
  }) async {
    final batchId = _uuid.v4();
    final operationId = _uuid.v4();
    final now = DateTime.now().toUtc();
    await _database.transaction(() async {
      await _database
          .into(_database.inventoryBatches)
          .insert(
            InventoryBatchesCompanion.insert(
              id: batchId,
              householdId: householdId,
              productId: productId,
              quantity: quantity.toDouble(),
              unit: unit,
              locationId: locationId,
              expiresOn: Value(expiresOn),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _database
          .into(_database.outboxOperations)
          .insert(
            OutboxOperationsCompanion.insert(
              operationId: operationId,
              userId: userId,
              householdId: householdId,
              entityType: 'inventory_batch',
              entityId: batchId,
              operationType: 'create',
              payload: jsonEncode({
                'batch_id': batchId,
                'product_id': productId,
                'quantity': quantity,
                'unit': unit,
                'location_id': locationId,
                'expires_on': expiresOn?.toIso8601String(),
              }),
              createdAt: now,
            ),
          );
    });
  }
}
