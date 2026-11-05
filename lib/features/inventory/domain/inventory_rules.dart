import 'dart:math' as math;

import 'inventory_models.dart';

class InventoryValidationException implements Exception {
  const InventoryValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}

void validateQuantity(num quantity, InventoryUnit unit) {
  if (!quantity.isFinite || quantity < 0) {
    throw const InventoryValidationException(
      'Quantity must be finite and non-negative.',
    );
  }
  final factor = math.pow(10, unit.scale);
  if ((quantity * factor).roundToDouble() != quantity * factor) {
    throw InventoryValidationException(
      'Quantity has more precision than ${unit.code} allows.',
    );
  }
}

List<InventoryBatch> fefoOrder(Iterable<InventoryBatch> batches) {
  final result = batches
      .where((batch) => !batch.archived && batch.quantity > 0)
      .toList();
  result.sort((a, b) {
    if (a.expiresOn == null && b.expiresOn != null) return 1;
    if (a.expiresOn != null && b.expiresOn == null) return -1;
    if (a.expiresOn != null && b.expiresOn != null) {
      final expiry = a.expiresOn!.compareTo(b.expiresOn!);
      if (expiry != 0) return expiry;
    }
    return a.createdAt.compareTo(b.createdAt);
  });
  return result;
}

bool isLowStock({required num available, required num threshold}) =>
    available <= threshold;

Map<String, num> consumeFefo(Iterable<InventoryBatch> batches, num requested) {
  if (!requested.isFinite || requested <= 0) {
    throw const InventoryValidationException(
      'Consumed quantity must be greater than zero.',
    );
  }
  var remaining = requested;
  final deductions = <String, num>{};
  for (final batch in fefoOrder(batches)) {
    if (remaining <= 0) break;
    final deduction = batch.quantity < remaining ? batch.quantity : remaining;
    deductions[batch.id] = deduction;
    remaining -= deduction;
  }
  if (remaining > 0) {
    throw const InventoryValidationException(
      'Quantity exceeds available stock.',
    );
  }
  return deductions;
}
