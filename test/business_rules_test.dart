import 'package:flutter_test/flutter_test.dart';

import 'package:pantry_mate/features/notifications/domain/notification_rules.dart';
import 'package:pantry_mate/features/shopping/domain/shopping_rules.dart';
import 'package:pantry_mate/infrastructure/synchronization/retry_policy.dart';
import 'package:pantry_mate/shared/household_permissions.dart';

void main() {
  test('shopping merge only combines same product and unit', () {
    const existing = ShoppingItemDraft(
      name: 'Milk',
      quantity: 1,
      unit: 'liter',
      productId: 'milk',
    );
    final merged = mergeShoppingItem(
      [existing],
      const ShoppingItemDraft(
        name: 'Milk',
        quantity: 2,
        unit: 'liter',
        productId: 'milk',
      ),
    );
    expect(merged.single.quantity, 3);
    expect(
      mergeShoppingItem(
        [existing],
        const ShoppingItemDraft(
          name: 'Milk',
          quantity: 2,
          unit: 'piece',
          productId: 'milk',
        ),
      ),
      hasLength(2),
    );
    expect(
      mergeShoppingItem([
        existing,
      ], const ShoppingItemDraft(name: 'Custom', quantity: 1, unit: 'liter')),
      hasLength(2),
    );
  });

  test('roles protect invitation, removal, and owner leave operations', () {
    expect(canInvite(HouseholdRole.owner, HouseholdRole.admin), isTrue);
    expect(canInvite(HouseholdRole.admin, HouseholdRole.admin), isFalse);
    expect(canRemoveMember(HouseholdRole.admin, HouseholdRole.admin), isFalse);
    expect(canLeave(HouseholdRole.owner), isFalse);
  });

  test(
    'notification defaults schedule at local 09:00 and quiet hours are deferred',
    () {
      final now = DateTime(2026, 11, 1, 10);
      expect(
        scheduleExpirationReminder(
          expirationDate: DateTime(2026, 11, 5),
          leadDays: 3,
          localNow: now,
        ),
        DateTime(2026, 11, 2, 9),
      );
      expect(isWithinQuietHours(DateTime(2026, 11, 1, 23)), isTrue);
      expect(isWithinQuietHours(DateTime(2026, 11, 1, 12)), isFalse);
      expect(
        snoozeExpirationReminder(DateTime(2026, 11, 2, 9)),
        DateTime(2026, 11, 3, 9),
      );
    },
  );

  test('retry backoff is bounded', () {
    expect(retryDelay(1), const Duration(seconds: 2));
    expect(retryDelay(5), const Duration(seconds: 32));
    expect(retryDelay(20), const Duration(minutes: 15));
  });
}
