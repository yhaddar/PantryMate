import 'package:flutter_test/flutter_test.dart';

import 'package:pantry_mate/infrastructure/synchronization/change_log_repository.dart';

void main() {
  test('cursor advances only to the highest applied revision', () {
    const cursor = ChangeCursor(4);
    final next = ChangeLogRepository.advance(cursor, const [
      RemoteChange(
        revision: 5,
        householdId: 'h',
        entityType: 'products',
        entityId: 'p',
        operation: 'update',
      ),
      RemoteChange(
        revision: 7,
        householdId: 'h',
        entityType: 'products',
        entityId: 'q',
        operation: 'delete',
      ),
    ]);
    expect(next.revision, 7);
  });

  test('delete changes are tombstones', () {
    const change = RemoteChange(
      revision: 1,
      householdId: 'h',
      entityType: 'products',
      entityId: 'p',
      operation: 'delete',
    );
    expect(change.isTombstone, isTrue);
  });
}
