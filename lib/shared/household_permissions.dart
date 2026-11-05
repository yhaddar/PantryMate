enum HouseholdRole { owner, admin, member }

bool canInvite(HouseholdRole actor, HouseholdRole invitedRole) {
  return switch (actor) {
    HouseholdRole.owner => invitedRole != HouseholdRole.owner,
    HouseholdRole.admin => invitedRole == HouseholdRole.member,
    HouseholdRole.member => false,
  };
}

bool canChangeRole(
  HouseholdRole actor,
  HouseholdRole targetRole,
  HouseholdRole newRole,
) {
  if (actor == HouseholdRole.owner) {
    return targetRole != HouseholdRole.owner && newRole != HouseholdRole.owner;
  }
  return actor == HouseholdRole.admin &&
      targetRole == HouseholdRole.member &&
      newRole == HouseholdRole.member;
}

bool canRemoveMember(HouseholdRole actor, HouseholdRole targetRole) {
  return switch (actor) {
    HouseholdRole.owner => targetRole != HouseholdRole.owner,
    HouseholdRole.admin => targetRole == HouseholdRole.member,
    HouseholdRole.member => false,
  };
}

bool canLeave(HouseholdRole role) => role != HouseholdRole.owner;
