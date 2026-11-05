import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../../infrastructure/database/local/app_database.dart';
import '../../features/inventory/data/local_inventory_repository.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

class ActiveHouseholdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String householdId) => state = householdId;
}

final activeHouseholdIdProvider =
    NotifierProvider<ActiveHouseholdNotifier, String?>(
      ActiveHouseholdNotifier.new,
    );

final localInventoryRepositoryProvider = Provider<LocalInventoryRepository>((
  ref,
) {
  return LocalInventoryRepository(ref.watch(databaseProvider));
});
