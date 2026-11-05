import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationPreferencesRepository {
  const NotificationPreferencesRepository(this._client);

  final SupabaseClient _client;

  Future<Map<String, bool>> load() async {
    final rows = await _client
        .from('notification_preferences')
        .select('category,enabled')
        .eq('user_id', _client.auth.currentUser!.id);
    return {
      for (final row in rows) row['category'] as String: row['enabled'] as bool,
    };
  }

  Future<void> setEnabled(String category, bool enabled) async {
    await _client.from('notification_preferences').upsert({
      'user_id': _client.auth.currentUser!.id,
      'category': category,
      'enabled': enabled,
    });
  }
}
