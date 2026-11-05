import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/household_models.dart';
import '../../../shared/household_permissions.dart';

class HouseholdRepository {
  const HouseholdRepository(this._client);

  final SupabaseClient _client;

  Future<Household> createHousehold(
    String name, {
    String timezone = 'UTC',
  }) async {
    final row = await _client.rpc(
      'create_household',
      params: {'p_name': name, 'p_timezone': timezone},
    );
    return Household(
      id: row['id'] as String,
      name: row['name'] as String,
      timezone: row['timezone'] as String,
    );
  }

  Future<List<HouseholdMembership>> memberships() async {
    final rows = await _client
        .from('household_members')
        .select('household_id,user_id,role');
    return rows
        .map(
          (row) => HouseholdMembership(
            householdId: row['household_id'] as String,
            userId: row['user_id'] as String,
            role: HouseholdRole.values.byName(row['role'] as String),
          ),
        )
        .toList();
  }

  Future<HouseholdMembership> acceptInvitation(String tokenHash) async {
    final row = await _client.rpc(
      'accept_invitation',
      params: {'p_token_hash': tokenHash},
    );
    return HouseholdMembership(
      householdId: row['household_id'] as String,
      userId: row['user_id'] as String,
      role: HouseholdRole.values.byName(row['role'] as String),
    );
  }
}
