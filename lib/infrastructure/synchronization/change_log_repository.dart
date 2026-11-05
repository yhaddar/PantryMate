import 'package:supabase_flutter/supabase_flutter.dart';

enum SyncOperationStatus { pending, processing, synced, failed }

class ChangeCursor {
  const ChangeCursor(this.revision);

  final int revision;
}

class RemoteChange {
  const RemoteChange({
    required this.revision,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.householdId,
  });

  final int revision;
  final String entityType;
  final String entityId;
  final String operation;
  final String householdId;

  bool get isTombstone => operation == 'delete';
}

class ChangeLogRepository {
  const ChangeLogRepository(this._client);

  final SupabaseClient _client;

  Future<List<RemoteChange>> after({
    required String householdId,
    required ChangeCursor cursor,
    int limit = 100,
  }) async {
    final rows = await _client
        .from('change_log')
        .select('revision,household_id,entity_type,entity_id,operation')
        .eq('household_id', householdId)
        .gt('revision', cursor.revision)
        .order('revision')
        .limit(limit);
    return rows
        .map(
          (row) => RemoteChange(
            revision: (row['revision'] as num).toInt(),
            householdId: row['household_id'] as String,
            entityType: row['entity_type'] as String,
            entityId: row['entity_id'] as String,
            operation: row['operation'] as String,
          ),
        )
        .toList();
  }

  static ChangeCursor advance(
    ChangeCursor cursor,
    Iterable<RemoteChange> changes,
  ) {
    final highest = changes.fold<int>(
      cursor.revision,
      (current, change) =>
          change.revision > current ? change.revision : current,
    );
    return ChangeCursor(highest);
  }
}
