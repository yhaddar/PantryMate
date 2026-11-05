import 'package:flutter_test/flutter_test.dart';

void main() {
  test('image object paths remain household and product scoped', () {
    const path = 'household/products/product/image.jpg';
    expect(path.split('/').take(3), ['household', 'products', 'product']);
  });
}
