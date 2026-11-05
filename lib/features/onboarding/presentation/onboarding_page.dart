import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _stepKey = 'onboarding_step';
  static const _storage = FlutterSecureStorage();
  int _step = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final value = await _storage.read(key: _stepKey);
    final parsed = int.tryParse(value ?? '');
    if (mounted) {
      setState(() {
        _step = parsed == null ? 0 : parsed.clamp(0, 4);
        _loading = false;
      });
    }
  }

  Future<void> _next() async {
    if (_step == 4) {
      await _storage.write(key: _stepKey, value: '5');
      if (mounted) context.go('/');
      return;
    }
    final next = _step + 1;
    await _storage.write(key: _stepKey, value: '$next');
    if (mounted) setState(() => _step = next);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final step = switch (_step) {
      0 => const _OnboardingStep(
        title: 'Welcome to PantryMate',
        body:
            'Keep household inventory, expiration dates, and shopping lists together.',
      ),
      1 => _OnboardingActionStep(
        title: 'Create or sign in to your account',
        body: 'Your account protects your household data across devices.',
        label: 'Open authentication',
        onPressed: () => context.push('/auth'),
      ),
      2 => _OnboardingActionStep(
        title: 'Create or join a household',
        body:
            'Household members share inventory and shopping activity according to their roles.',
        label: 'Manage households',
        onPressed: () => context.push('/households'),
      ),
      3 => _OnboardingActionStep(
        title: 'Choose notification preferences',
        body:
            'Expiration and low-stock reminders are configurable and permission-aware.',
        label: 'Open notifications',
        onPressed: () => context.push('/settings/notifications'),
      ),
      _ => const _OnboardingStep(
        title: 'Start with your pantry',
        body:
            'Add products, record inventory locally, and use shopping lists when you are ready.',
      ),
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Getting started')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: (_step + 1) / 5),
            const SizedBox(height: 32),
            Expanded(child: step),
            FilledButton(
              onPressed: _next,
              child: Text(_step == 4 ? 'Finish' : 'Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 16),
      Text(body, style: Theme.of(context).textTheme.bodyLarge),
    ],
  );
}

class _OnboardingActionStep extends StatelessWidget {
  const _OnboardingActionStep({
    required this.title,
    required this.body,
    required this.label,
    required this.onPressed,
  });

  final String title;
  final String body;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 16),
      Text(body, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 24),
      OutlinedButton(onPressed: onPressed, child: Text(label)),
    ],
  );
}
