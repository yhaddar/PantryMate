import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pantry_mate/app/app.dart';

void main() {
  testWidgets('dashboard renders the initial household state', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PantryMateApp()));
    await tester.pumpAndSettle();

    expect(find.text('PantryMate'), findsOneWidget);
    expect(find.text('Your household pantry'), findsOneWidget);
    expect(find.text('Open inventory'), findsOneWidget);
  });
}
