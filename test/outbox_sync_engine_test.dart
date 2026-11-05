import 'package:flutter_test/flutter_test.dart';

import 'package:pantry_mate/infrastructure/synchronization/retry_policy.dart';

void main() {
  test('failed operations use increasing bounded retry delays', () {
    expect(retryDelay(1) < retryDelay(2), isTrue);
    expect(retryDelay(100), const Duration(minutes: 15));
  });
}
