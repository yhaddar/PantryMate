import 'package:flutter_test/flutter_test.dart';

import 'package:pantry_mate/features/inventory/domain/inventory_models.dart';
import 'package:pantry_mate/features/inventory/domain/inventory_rules.dart';

void main() {
  final now = DateTime(2026, 11, 5);
  final soon = InventoryBatch(
    id: 'soon',
    productId: 'p',
    quantity: 2,
    unit: InventoryUnit.piece,
    createdAt: now,
  );

  test('classifies date-only expiration without shifting timezone', () {
    expect(
      expirationStatus(DateTime(2026, 11, 5), now),
      ExpirationStatus.expiringSoon,
    );
    expect(
      expirationStatus(DateTime(2026, 11, 1), now),
      ExpirationStatus.expired,
    );
    expect(expirationStatus(null, now), ExpirationStatus.none);
  });

  test('orders FEFO before undated batches', () {
    final dated = InventoryBatch(
      id: 'dated',
      productId: 'p',
      quantity: 1,
      unit: InventoryUnit.piece,
      createdAt: now,
      expiresOn: now.add(const Duration(days: 1)),
    );
    expect(fefoOrder([soon, dated]).map((batch) => batch.id), [
      'dated',
      'soon',
    ]);
  });

  test('consumption rejects insufficient stock', () {
    expect(consumeFefo([soon], 2), {'soon': 2});
    expect(
      () => consumeFefo([soon], 3),
      throwsA(isA<InventoryValidationException>()),
    );
  });

  test('quantity precision follows unit', () {
    expect(
      () => validateQuantity(1.1, InventoryUnit.piece),
      throwsA(isA<InventoryValidationException>()),
    );
    expect(
      () => validateQuantity(1.125, InventoryUnit.kilogram),
      returnsNormally,
    );
  });
}
