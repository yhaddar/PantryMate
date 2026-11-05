import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/app_providers.dart';
import '../data/activity_repository.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final householdId = ref.watch(activeHouseholdIdProvider);
    if (!ref.watch(appConfigProvider).hasSupabase) {
      return const Scaffold(
        body: Center(child: Text('Configure Supabase to view activity.')),
      );
    }
    if (householdId == null) {
      return const Scaffold(
        body: Center(child: Text('Select a household to view activity.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: FutureBuilder<List<ActivityEvent>>(
        future: ActivityRepository(Supabase.instance.client).list(householdId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Unable to load activity: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No household activity yet.'));
          }
          return ListView(
            children: snapshot.data!
                .map(
                  (event) => ListTile(
                    title: Text(event.summary),
                    subtitle: Text(event.createdAt.toLocal().toString()),
                    leading: const Icon(Icons.history_outlined),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
