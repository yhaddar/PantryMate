import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final householdId = ref.watch(activeHouseholdIdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: householdId == null
          ? const _NoHouseholdState()
          : StreamBuilder(
              stream: ref
                  .read(localInventoryRepositoryProvider)
                  .watchBatches(householdId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _ErrorState(message: snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final batches = snapshot.data!;
                if (batches.isEmpty) return const _EmptyState();
                return ListView.builder(
                  itemCount: batches.length,
                  itemBuilder: (context, index) {
                    final batch = batches[index];
                    return ListTile(
                      title: Text(batch.productId),
                      subtitle: Text('${batch.quantity} ${batch.unit}'),
                      trailing: batch.expiresOn == null
                          ? null
                          : Text(_dateOnly(batch.expiresOn!)),
                    );
                  },
                );
              },
            ),
    );
  }

  String _dateOnly(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

class _NoHouseholdState extends StatelessWidget {
  const _NoHouseholdState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Sign in and select a household to view inventory.'),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No active inventory batches yet.'));
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Unable to load inventory: $message'));
  }
}
