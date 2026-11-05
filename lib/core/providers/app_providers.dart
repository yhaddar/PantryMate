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

final activeHouseholdIdProvider = Provider<String?>((ref) => null);

final localInventoryRepositoryProvider = Provider<LocalInventoryRepository>((
  ref,
) {
  return LocalInventoryRepository(ref.watch(databaseProvider));
});
