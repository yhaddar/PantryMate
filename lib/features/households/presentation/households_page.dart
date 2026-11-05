import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/app_providers.dart';
import '../data/household_repository.dart';
import '../domain/household_models.dart';

class HouseholdsPage extends ConsumerStatefulWidget {
  const HouseholdsPage({super.key});

  @override
  ConsumerState<HouseholdsPage> createState() => _HouseholdsPageState();
}

class _HouseholdsPageState extends ConsumerState<HouseholdsPage> {
  late Future<List<Household>> _households;
  final _name = TextEditingController();
  bool _creating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _households = _load();
  }

  Future<List<Household>> _load() {
    if (!ref.read(appConfigProvider).hasSupabase) return Future.value(const []);
    return HouseholdRepository(Supabase.instance.client).accessibleHouseholds();
  }

  Future<void> _create() async {
    if (_name.text.trim().isEmpty) return;
    setState(() {
      _creating = true;
      _error = null;
    });
    try {
      await HouseholdRepository(
        Supabase.instance.client,
      ).createHousehold(_name.text.trim());
      _name.clear();
      setState(() => _households = _load());
    } on PostgrestException catch (error) {
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configured = ref.watch(appConfigProvider).hasSupabase;
    return Scaffold(
      appBar: AppBar(title: const Text('Households')),
      body: !configured
          ? const Center(
              child: Text('Configure Supabase to manage households.'),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'New household name',
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _creating ? null : _create,
                  child: const Text('Create household'),
                ),
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                const SizedBox(height: 24),
                FutureBuilder<List<Household>>(
                  future: _households,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'Unable to load households: ${snapshot.error}',
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.isEmpty) {
                      return const Text('No accessible households.');
                    }
                    return Column(
                      children: snapshot.data!
                          .map(
                            (household) => ListTile(
                              title: Text(household.name),
                              subtitle: Text(household.timezone),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
