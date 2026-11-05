import '../../../shared/household_permissions.dart';

class Household {
  const Household({
    required this.id,
    required this.name,
    required this.timezone,
  });

  final String id;
  final String name;
  final String timezone;
}

class HouseholdMembership {
  const HouseholdMembership({
    required this.householdId,
    required this.userId,
    required this.role,
  });

  final String householdId;
  final String userId;
  final HouseholdRole role;
}
