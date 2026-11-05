import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../../infrastructure/database/local/app_database.dart';
import '../../features/inventory/data/local_inventory_repository.dart';
import '../../features/dashboard/data/local_dashboard_repository.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setMode(ThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
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

final localDashboardRepositoryProvider = Provider<LocalDashboardRepository>((
  ref,
) {
  return LocalDashboardRepository(ref.watch(databaseProvider));
});
