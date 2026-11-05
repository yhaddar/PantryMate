import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/app_providers.dart';
import '../../notifications/data/notification_preferences_repository.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  final _categories = const [
    'expiration',
    'low_stock',
    'invitation',
    'shopping_activity',
  ];
  Map<String, bool> _values = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final config = ref.read(appConfigProvider);
    if (!config.hasSupabase ||
        Supabase.instance.client.auth.currentUser == null) {
      setState(() {
        _loading = false;
        _error = 'Sign in to manage notification preferences.';
      });
      return;
    }
    try {
      final loaded = await NotificationPreferencesRepository(
        Supabase.instance.client,
      ).load();
      setState(() {
        _values = {
          for (final category in _categories)
            category: loaded[category] ?? true,
        };
        _loading = false;
      });
    } on PostgrestException catch (error) {
      setState(() {
        _loading = false;
        _error = error.message;
      });
    }
  }

  Future<void> _set(String category, bool value) async {
    setState(() => _values[category] = value);
    try {
      await NotificationPreferencesRepository(
        Supabase.instance.client,
      ).setEnabled(category, value);
    } on PostgrestException catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _values.isEmpty
          ? Center(child: Text(_error!))
          : ListView(
              children: [
                if (_error != null)
                  ListTile(
                    title: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ..._categories.map(
                  (category) => SwitchListTile(
                    title: Text(_label(category)),
                    value: _values[category] ?? true,
                    onChanged: (value) => _set(category, value),
                  ),
                ),
              ],
            ),
    );
  }

  String _label(String value) => value
      .replaceAll('_', ' ')
      .split(' ')
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
