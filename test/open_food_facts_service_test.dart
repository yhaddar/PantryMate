import 'package:flutter_test/flutter_test.dart';

import 'package:pantry_mate/infrastructure/external_apis/open_food_facts_service.dart';

void main() {
  test('lookup failure classification is explicit', () {
    const exception = ProductLookupException(
      ProductLookupFailure.notFound,
      'missing',
    );
    expect(exception.kind, ProductLookupFailure.notFound);
  });
}
