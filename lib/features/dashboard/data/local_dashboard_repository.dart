import 'package:drift/drift.dart';

import '../../../infrastructure/database/local/app_database.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.activeBatches,
    required this.expiredBatches,
    required this.expiringSoonBatches,
  });

  final int activeBatches;
  final int expiredBatches;
  final int expiringSoonBatches;
}

class SyncStatusSummary {
  const SyncStatusSummary({required this.pending, required this.failed});

  final int pending;
  final int failed;

  bool get needsAttention => pending > 0 || failed > 0;
}

class LocalDashboardRepository {
  const LocalDashboardRepository(this._database);

  final AppDatabase _database;

  Future<DashboardSummary> load(String householdId, {DateTime? today}) async {
    final current = today ?? DateTime.now();
    final batches =
        await (_database.select(_database.inventoryBatches)..where(
              (row) =>
                  row.householdId.equals(householdId) &
                  row.archived.equals(false),
            ))
            .get();
    final active = batches.where((batch) => batch.quantity > 0).toList();
    final currentDate = _date(current);
    final expired = active
        .where(
          (batch) =>
              batch.expiresOn != null &&
              _date(batch.expiresOn!).isBefore(currentDate),
        )
        .length;
    final soon = active.where((batch) {
      if (batch.expiresOn == null) return false;
      final date = _date(batch.expiresOn!);
      return !date.isBefore(currentDate) &&
          !date.isAfter(currentDate.add(const Duration(days: 3)));
    }).length;
    return DashboardSummary(
      activeBatches: active.length,
      expiredBatches: expired,
      expiringSoonBatches: soon,
    );
  }

  Future<SyncStatusSummary> loadSyncStatus(String householdId) async {
    final operations = await (_database.select(
      _database.outboxOperations,
    )..where((row) => row.householdId.equals(householdId))).get();
    return SyncStatusSummary(
      pending: operations
          .where(
            (operation) =>
                operation.status == 'pending' ||
                operation.status == 'processing',
          )
          .length,
      failed: operations
          .where((operation) => operation.status == 'failed')
          .length,
    );
  }

  DateTime _date(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
