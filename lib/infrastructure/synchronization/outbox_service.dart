import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/local/app_database.dart';
import 'retry_policy.dart';

class OutboxService {
  OutboxService(this._database, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _database;
  final Uuid _uuid;

  Future<String> enqueue({
    required String userId,
    required String householdId,
    required String entityType,
    required String entityId,
    required String operationType,
    required Map<String, dynamic> payload,
  }) async {
    final operationId = _uuid.v4();
    await _database.enqueue(
      OutboxOperationsCompanion.insert(
        operationId: operationId,
        userId: userId,
        householdId: householdId,
        entityType: entityType,
        entityId: entityId,
        operationType: operationType,
        payload: jsonEncode(payload),
        createdAt: DateTime.now().toUtc(),
      ),
    );
    return operationId;
  }

  Future<void> markFailed(String operationId, String error, int attempt) {
    return (_database.update(
      _database.outboxOperations,
    )..where((row) => row.operationId.equals(operationId))).write(
      OutboxOperationsCompanion(
        status: const Value('failed'),
        attemptCount: Value(attempt),
        lastError: Value(error),
        nextAttemptAt: Value(DateTime.now().toUtc().add(retryDelay(attempt))),
      ),
    );
  }
}
