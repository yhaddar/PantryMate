import 'package:flutter_test/flutter_test.dart';

import 'package:pantry_mate/features/data_management/domain/inventory_import.dart';
import 'package:pantry_mate/features/reports/data/csv_inventory_codec.dart';

void main() {
  const validator = InventoryImportValidator(InventoryCsvCodec());

  test(
    'CSV import previews valid rows and rejects invalid rows before apply',
    () {
      final preview = validator.preview(
        'product,quantity,unit,expires_on,location\nBeans,2,piece,2026-12-01,Shelf\nMilk,-1,liter,,Fridge',
      );
      expect(preview.validRows, hasLength(1));
      expect(preview.errors, hasLength(1));
      expect(preview.canApply, isFalse);
    },
  );

  test('CSV import rejects an invalid header', () {
    final preview = validator.preview('name,quantity\nBeans,2');
    expect(preview.errors.single.message, contains('Header'));
  });

  test('CSV import requires a date-only expiration value', () {
    final preview = validator.preview(
      'product,quantity,unit,expires_on,location\nBeans,2,piece,2026-12-01T09:00:00,Shelf',
    );

    expect(preview.validRows, isEmpty);
    expect(preview.errors.single.message, contains('ISO date'));
  });
}
