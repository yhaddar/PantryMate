import 'package:csv/csv.dart';

class InventoryCsvCodec {
  const InventoryCsvCodec();

  String encode(Iterable<Map<String, String>> rows) {
    final values = <List<String>>[
      ['product', 'quantity', 'unit', 'expires_on', 'location'],
      ...rows.map(
        (row) => [
          row['product'] ?? '',
          row['quantity'] ?? '',
          row['unit'] ?? '',
          row['expires_on'] ?? '',
          row['location'] ?? '',
        ],
      ),
    ];
    return Csv().encode(values);
  }

  List<List<dynamic>> decode(String csv) => Csv().decode(csv);
}
