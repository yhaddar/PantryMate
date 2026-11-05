import '../../reports/data/csv_inventory_codec.dart';

class InventoryImportError {
  const InventoryImportError(this.row, this.message);

  final int row;
  final String message;
}

class InventoryImportPreview {
  const InventoryImportPreview({required this.validRows, required this.errors});

  final List<Map<String, String>> validRows;
  final List<InventoryImportError> errors;

  bool get canApply => errors.isEmpty && validRows.isNotEmpty;
}

class InventoryImportValidator {
  const InventoryImportValidator(this._codec);

  final InventoryCsvCodec _codec;

  InventoryImportPreview preview(String csv) {
    final rows = _codec.decode(csv);
    if (rows.isEmpty) {
      return const InventoryImportPreview(validRows: [], errors: []);
    }
    final errors = <InventoryImportError>[];
    final valid = <Map<String, String>>[];
    final headers = rows.first.map((value) => value.toString().trim()).toList();
    const required = ['product', 'quantity', 'unit', 'expires_on', 'location'];
    if (headers.length != required.length ||
        headers.asMap().entries.any(
          (entry) => entry.value != required[entry.key],
        )) {
      return const InventoryImportPreview(
        validRows: [],
        errors: [
          InventoryImportError(
            1,
            'Header must be product, quantity, unit, expires_on, location.',
          ),
        ],
      );
    }
    for (var index = 1; index < rows.length; index++) {
      final row = rows[index];
      if (row.length != headers.length) {
        errors.add(
          InventoryImportError(
            index + 1,
            'Row has the wrong number of columns.',
          ),
        );
        continue;
      }
      final values = <String, String>{
        for (var column = 0; column < headers.length; column++)
          headers[column]: row[column].toString().trim(),
      };
      final quantity = num.tryParse(values['quantity']!);
      if (values['product']!.isEmpty ||
          values['unit']!.isEmpty ||
          values['location']!.isEmpty ||
          quantity == null ||
          quantity <= 0) {
        errors.add(
          InventoryImportError(
            index + 1,
            'Product, unit, location, and positive quantity are required.',
          ),
        );
        continue;
      }
      if (values['expires_on']!.isNotEmpty &&
          DateTime.tryParse(values['expires_on']!) == null) {
        errors.add(
          InventoryImportError(
            index + 1,
            'Expiration date must be ISO date format.',
          ),
        );
        continue;
      }
      valid.add(values);
    }
    return InventoryImportPreview(validRows: valid, errors: errors);
  }
}
