import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../infrastructure/security/app_lock_service.dart';

class AppearanceSettingsPage extends ConsumerStatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  ConsumerState<AppearanceSettingsPage> createState() =>
      _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState
    extends ConsumerState<AppearanceSettingsPage> {
  bool _appLockEnabled = false;
  bool _loadingLock = true;
  String? _lockMessage;

  @override
  void initState() {
    super.initState();
    _loadLock();
  }

  Future<void> _loadLock() async {
    final enabled = await AppLockService().isEnabled();
    if (mounted) {
      setState(() {
        _appLockEnabled = enabled;
        _loadingLock = false;
      });
    }
  }

  Future<void> _setAppLock(bool enabled) async {
    setState(() => _lockMessage = null);
    final service = AppLockService();
    if (enabled && !await service.authenticate()) {
      if (mounted) {
        setState(
          () => _lockMessage = 'Biometric verification was not completed.',
        );
      }
      return;
    }
    final saved = await service.setEnabled(enabled);
    if (!saved) {
      if (mounted) {
        setState(
          () => _lockMessage =
              'Biometric authentication is unavailable on this device.',
        );
      }
      return;
    }
    if (mounted) setState(() => _appLockEnabled = enabled);
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance and accessibility')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Theme',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.settings_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode_outlined),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (selection) =>
                ref.read(themeModeProvider.notifier).setMode(selection.first),
          ),
          const SizedBox(height: 24),
          const Card(
            child: ListTile(
              leading: Icon(Icons.accessibility_new_outlined),
              title: Text('Accessibility support'),
              subtitle: Text(
                'PantryMate uses semantic labels, scalable text, clear states, and large touch targets throughout the app.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Biometric app lock'),
            subtitle: const Text(
              'Require Face ID, Touch ID, or Android biometrics when opening PantryMate.',
            ),
            value: _appLockEnabled,
            onChanged: _loadingLock ? null : _setAppLock,
          ),
          if (_lockMessage != null)
            Text(
              _lockMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
    );
  }
}
