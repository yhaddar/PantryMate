import 'package:drift/drift.dart';

import '../database/local/app_database.dart';
import 'retry_policy.dart';

typedef SendOutboxOperation = Future<void> Function(OutboxOperation operation);

class OutboxSyncEngine {
  const OutboxSyncEngine(this._database);

  final AppDatabase _database;

  Future<int> process({
    required String userId,
    required String householdId,
    required SendOutboxOperation send,
    DateTime? now,
  }) async {
    final current = now ?? DateTime.now().toUtc();
    final operations = await _database.select(_database.outboxOperations).get();
    final eligible = operations.where((operation) {
      if (operation.userId != userId || operation.householdId != householdId) {
        return false;
      }
      if (operation.status != 'pending' && operation.status != 'failed') {
        return false;
      }
      return operation.nextAttemptAt == null ||
          !operation.nextAttemptAt!.isAfter(current);
    });
    var processed = 0;
    for (final operation in eligible) {
      await (_database.update(_database.outboxOperations)
            ..where((row) => row.operationId.equals(operation.operationId)))
          .write(const OutboxOperationsCompanion(status: Value('processing')));
      try {
        await send(operation);
        await (_database.update(_database.outboxOperations)
              ..where((row) => row.operationId.equals(operation.operationId)))
            .write(const OutboxOperationsCompanion(status: Value('synced')));
      } catch (error) {
        final attempt = operation.attemptCount + 1;
        await (_database.update(
          _database.outboxOperations,
        )..where((row) => row.operationId.equals(operation.operationId))).write(
          OutboxOperationsCompanion(
            status: const Value('failed'),
            attemptCount: Value(attempt),
            lastError: Value(error.toString()),
            nextAttemptAt: Value(current.add(retryDelay(attempt))),
          ),
        );
      }
      processed++;
    }
    return processed;
  }
}
