import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/inventory/presentation/inventory_page.dart';
import '../features/inventory/presentation/add_inventory_page.dart';
import '../features/auth/presentation/auth_page.dart';
import '../features/households/presentation/households_page.dart';
import '../features/products/presentation/products_page.dart';
import '../features/shopping/presentation/shopping_page.dart';
import '../features/dashboard/data/local_dashboard_repository.dart';
import '../core/providers/app_providers.dart';
import '../features/settings/presentation/notification_settings_page.dart';
import '../features/reports/presentation/reports_page.dart';
import '../features/settings/presentation/appearance_settings_page.dart';
import '../features/activity/presentation/activity_page.dart';
import '../features/data_management/presentation/feedback_page.dart';
import '../features/onboarding/presentation/onboarding_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
    GoRoute(
      path: '/households',
      builder: (context, state) => const HouseholdsPage(),
    ),
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const InventoryPage(),
    ),
    GoRoute(
      path: '/inventory/add',
      builder: (context, state) => const AddInventoryPage(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsPage(),
    ),
    GoRoute(
      path: '/shopping',
      builder: (context, state) => const ShoppingPage(),
    ),
    GoRoute(
      path: '/settings/notifications',
      builder: (context, state) => const NotificationSettingsPage(),
    ),
    GoRoute(path: '/reports', builder: (context, state) => const ReportsPage()),
    GoRoute(
      path: '/settings/appearance',
      builder: (context, state) => const AppearanceSettingsPage(),
    ),
    GoRoute(
      path: '/activity',
      builder: (context, state) => const ActivityPage(),
    ),
    GoRoute(
      path: '/settings/feedback',
      builder: (context, state) => const FeedbackPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
  ],
);

class PantryMateApp extends ConsumerWidget {
  const PantryMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'PantryMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff2f6f4e)),
        useMaterial3: true,
      ),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: _router,
    );
  }
}

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final householdId = ref.watch(activeHouseholdIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PantryMate'),
        actions: [
          PopupMenuButton<String>(
            onSelected: context.push,
            itemBuilder: (context) => const [
              PopupMenuItem(value: '/auth', child: Text('Sign in')),
              PopupMenuItem(value: '/households', child: Text('Households')),
              PopupMenuItem(value: '/products', child: Text('Products')),
              PopupMenuItem(value: '/shopping', child: Text('Shopping')),
              PopupMenuItem(
                value: '/settings/notifications',
                child: Text('Notifications'),
              ),
              PopupMenuItem(
                value: '/settings/appearance',
                child: Text('Appearance'),
              ),
              PopupMenuItem(value: '/activity', child: Text('Activity')),
              PopupMenuItem(
                value: '/settings/feedback',
                child: Text('Help and feedback'),
              ),
              PopupMenuItem(
                value: '/onboarding',
                child: Text('Getting started'),
              ),
              PopupMenuItem(value: '/reports', child: Text('Reports')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Your household pantry',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Inventory, expiry reminders, and shopping in one place.'),
          const SizedBox(height: 24),
          _SummaryCard(
            label: 'Inventory',
            value: 'Open inventory',
            icon: Icons.inventory_2_outlined,
            onTap: () => context.push('/inventory'),
          ),
          if (householdId == null)
            const _SummaryCard(
              label: 'Inventory',
              value: 'Select a household to see local data',
              icon: Icons.inventory_2_outlined,
            )
          else
            FutureBuilder<DashboardSummary>(
              future: ref
                  .read(localDashboardRepositoryProvider)
                  .load(householdId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Card(
                    child: ListTile(title: Text('Loading dashboard…')),
                  );
                }
                final summary = snapshot.data!;
                return Column(
                  children: [
                    _SummaryCard(
                      label: 'Active inventory',
                      value: '${summary.activeBatches} batches',
                      icon: Icons.inventory_2_outlined,
                    ),
                    _SummaryCard(
                      label: 'Expiring soon',
                      value: '${summary.expiringSoonBatches} batches',
                      icon: Icons.schedule_outlined,
                    ),
                    _SummaryCard(
                      label: 'Expired',
                      value: '${summary.expiredBatches} batches',
                      icon: Icons.warning_amber_outlined,
                    ),
                  ],
                );
              },
            ),
          if (householdId != null)
            FutureBuilder<SyncStatusSummary>(
              future: ref
                  .read(localDashboardRepositoryProvider)
                  .loadSyncStatus(householdId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final status = snapshot.data!;
                return _SummaryCard(
                  label: status.failed > 0
                      ? 'Synchronization needs attention'
                      : 'Synchronization',
                  value: status.needsAttention
                      ? '${status.pending} pending · ${status.failed} failed locally'
                      : 'All local changes are synchronized',
                  icon: status.failed > 0
                      ? Icons.sync_problem_outlined
                      : Icons.sync_outlined,
                );
              },
            ),
          const _SummaryCard(
            label: 'Shopping list',
            value: 'Open shopping to view shared lists',
            icon: Icons.shopping_cart_outlined,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
