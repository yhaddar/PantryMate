import 'package:flutter_test/flutter_test.dart';

import 'package:pantry_mate/features/products/domain/product_models.dart';
import 'package:pantry_mate/features/reports/data/csv_inventory_codec.dart';

void main() {
  test('barcode takes precedence in duplicate detection', () {
    const existing = Product(
      id: '1',
      householdId: 'h',
      name: 'Milk',
      categoryId: 'dairy',
      baseUnit: 'liter',
      barcode: '123',
    );
    expect(
      isPotentialDuplicate(
        const Product(
          id: '2',
          householdId: 'h',
          name: 'Different',
          categoryId: 'dairy',
          baseUnit: 'liter',
          barcode: '123',
        ),
        [existing],
      ),
      isTrue,
    );
    expect(
      isPotentialDuplicate(
        const Product(
          id: '3',
          householdId: 'h',
          name: 'Milk',
          categoryId: 'dairy',
          baseUnit: 'liter',
        ),
        [existing],
      ),
      isTrue,
    );
  });

  test('CSV export round-trips escaped values', () {
    const codec = InventoryCsvCodec();
    final csv = codec.encode([
      {
        'product': 'Beans, red',
        'quantity': '2',
        'unit': 'piece',
        'expires_on': '',
        'location': 'Shelf',
      },
    ]);
    final rows = codec.decode(csv);
    expect(rows[1][0], 'Beans, red');
    expect(rows[1][4], 'Shelf');
  });
}
