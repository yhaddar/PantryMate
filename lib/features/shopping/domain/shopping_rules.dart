class ShoppingItemDraft {
  const ShoppingItemDraft({
    required this.name,
    required this.quantity,
    required this.unit,
    this.productId,
  });

  final String name;
  final num quantity;
  final String unit;
  final String? productId;
}

List<ShoppingItemDraft> mergeShoppingItem(
  Iterable<ShoppingItemDraft> items,
  ShoppingItemDraft incoming,
) {
  final result = items.toList();
  final index = result.indexWhere(
    (item) =>
        item.productId == incoming.productId &&
        item.unit == incoming.unit &&
        item.productId != null,
  );
  if (index == -1) return [...result, incoming];
  final existing = result[index];
  result[index] = ShoppingItemDraft(
    name: existing.name,
    quantity: existing.quantity + incoming.quantity,
    unit: existing.unit,
    productId: existing.productId,
  );
  return result;
}

enum ShoppingPriority { low, normal, high }
