enum InventoryUnit { piece, gram, kilogram, milliliter, liter }

extension InventoryUnitRules on InventoryUnit {
  int get scale => switch (this) {
    InventoryUnit.piece => 0,
    InventoryUnit.gram => 0,
    InventoryUnit.kilogram => 3,
    InventoryUnit.milliliter => 0,
    InventoryUnit.liter => 3,
  };

  String get code => name;
}

class InventoryBatch {
  const InventoryBatch({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unit,
    required this.createdAt,
    this.expiresOn,
    this.archived = false,
  });

  final String id;
  final String productId;
  final num quantity;
  final InventoryUnit unit;
  final DateTime createdAt;
  final DateTime? expiresOn;
  final bool archived;
}

enum ExpirationStatus { none, expired, expiringSoon, fresh }

ExpirationStatus expirationStatus(
  DateTime? expiresOn,
  DateTime today, {
  int leadDays = 3,
}) {
  if (expiresOn == null) return ExpirationStatus.none;
  final expiryDate = DateTime(expiresOn.year, expiresOn.month, expiresOn.day);
  final currentDate = DateTime(today.year, today.month, today.day);
  if (expiryDate.isBefore(currentDate)) return ExpirationStatus.expired;
  if (!expiryDate.isAfter(currentDate.add(Duration(days: leadDays)))) {
    return ExpirationStatus.expiringSoon;
  }
  return ExpirationStatus.fresh;
}

num availableQuantity(Iterable<InventoryBatch> batches, DateTime today) {
  return batches
      .where((batch) => !batch.archived && batch.quantity > 0)
      .where(
        (batch) =>
            batch.expiresOn == null ||
            expirationStatus(batch.expiresOn, today) !=
                ExpirationStatus.expired,
      )
      .fold<num>(0, (total, batch) => total + batch.quantity);
}
