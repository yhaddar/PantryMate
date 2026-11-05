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

  Future<List<Household>> accessibleHouseholds() async {
    final rows = await _client
        .from('households')
        .select('id,name,timezone')
        .order('name');
    return rows
        .map(
          (row) => Household(
            id: row['id'] as String,
            name: row['name'] as String,
            timezone: row['timezone'] as String,
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

  Future<void> transferOwnership(String householdId, String newOwnerId) {
    return _client.rpc(
      'transfer_household_ownership',
      params: {'p_household_id': householdId, 'p_new_owner': newOwnerId},
    );
  }

  Future<void> removeMember(String householdId, String userId) {
    return _client.rpc(
      'remove_household_member',
      params: {'p_household_id': householdId, 'p_user_id': userId},
    );
  }

  Future<DateTime> requestDeletion(String householdId) async {
    final result = await _client.rpc(
      'request_household_deletion',
      params: {'p_household_id': householdId},
    );
    return DateTime.parse(result as String);
  }

  Future<void> cancelDeletion(String householdId) {
    return _client.rpc(
      'cancel_household_deletion',
      params: {'p_household_id': householdId},
    );
  }
}
