import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/inventory/presentation/inventory_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const InventoryPage(),
    ),
  ],
);

class PantryMateApp extends StatelessWidget {
  const PantryMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PantryMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff2f6f4e)),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PantryMate')),
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
          const _SummaryCard(
            label: 'Expiring soon',
            value: 'No household selected',
            icon: Icons.schedule_outlined,
          ),
          const _SummaryCard(
            label: 'Shopping list',
            value: 'No household selected',
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
