import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../infrastructure/database/local/app_database.dart';

class LocalInventoryRepository {
  LocalInventoryRepository(this._database, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _database;
  final Uuid _uuid;

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
