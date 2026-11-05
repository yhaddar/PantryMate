import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../../infrastructure/database/local/app_database.dart';
import '../../features/inventory/data/local_inventory_repository.dart';
import '../../features/dashboard/data/local_dashboard_repository.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _storageKey = 'theme_mode';

  @override
  ThemeMode build() {
    unawaited(_restore());
    return ThemeMode.system;
  }

  void setMode(ThemeMode mode) {
    state = mode;
    unawaited(
      const FlutterSecureStorage().write(key: _storageKey, value: mode.name),
    );
  }

  Future<void> _restore() async {
    final stored = await const FlutterSecureStorage().read(key: _storageKey);
    if (stored == null) return;
    final mode = ThemeMode.values.where((value) => value.name == stored);
    if (mode.isNotEmpty) state = mode.first;
  }
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
