class ShoppingList {
  const ShoppingList({
    required this.id,
    required this.householdId,
    required this.name,
    required this.isDefault,
  });

  final String id;
  final String householdId;
  final String name;
  final bool isDefault;
}

class ShoppingItem {
  const ShoppingItem({
    required this.id,
    required this.listId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.priority,
    this.purchasedAt,
  });

  final String id;
  final String listId;
  final String name;
  final num quantity;
  final String unit;
  final String priority;
  final DateTime? purchasedAt;
}
