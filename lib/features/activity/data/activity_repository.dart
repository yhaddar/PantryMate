import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityEvent {
  const ActivityEvent({
    required this.id,
    required this.eventType,
    required this.summary,
    required this.createdAt,
  });

  final String id;
  final String eventType;
  final String summary;
  final DateTime createdAt;
}

class ActivityRepository {
  const ActivityRepository(this._client);

  final SupabaseClient _client;

  Future<List<ActivityEvent>> list(String householdId, {int limit = 50}) async {
    final rows = await _client
        .from('activity_events')
        .select('id,event_type,summary,created_at')
        .eq('household_id', householdId)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows
        .map(
          (row) => ActivityEvent(
            id: row['id'] as String,
            eventType: row['event_type'] as String,
            summary: row['summary'] as String,
            createdAt: DateTime.parse(row['created_at'] as String),
          ),
        )
        .toList();
  }
}
