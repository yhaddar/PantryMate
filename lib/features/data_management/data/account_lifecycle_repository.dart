import 'package:supabase_flutter/supabase_flutter.dart';

class AccountLifecycleRepository {
  const AccountLifecycleRepository(this._client);

  final SupabaseClient _client;

  Future<DateTime> requestDeletion() async {
    final result = await _client.rpc('request_account_deletion');
    return DateTime.parse(result as String);
  }

  Future<void> signOut() => _client.auth.signOut();
}
