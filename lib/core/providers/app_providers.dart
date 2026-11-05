import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/database/local/app_database.dart';
import '../../features/inventory/data/local_inventory_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final activeHouseholdIdProvider = Provider<String?>((ref) => null);

final localInventoryRepositoryProvider = Provider<LocalInventoryRepository>((
  ref,
) {
  return LocalInventoryRepository(ref.watch(databaseProvider));
});
