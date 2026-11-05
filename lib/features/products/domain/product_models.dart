class Product {
  const Product({
    required this.id,
    required this.householdId,
    required this.name,
    required this.categoryId,
    required this.baseUnit,
    this.barcode,
    this.brand,
    this.notes,
    this.archived = false,
  });

  final String id;
  final String householdId;
  final String name;
  final String categoryId;
  final String baseUnit;
  final String? barcode;
  final String? brand;
  final String? notes;
  final bool archived;
}

bool isPotentialDuplicate(Product candidate, Iterable<Product> existing) {
  return existing.any((product) {
    if (candidate.barcode != null && product.barcode != null) {
      return candidate.barcode == product.barcode;
    }
    return candidate.name.trim().toLowerCase() ==
            product.name.trim().toLowerCase() &&
        (candidate.brand ?? '').trim().toLowerCase() ==
            (product.brand ?? '').trim().toLowerCase();
  });
}
