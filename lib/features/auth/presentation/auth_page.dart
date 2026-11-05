import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/app_providers.dart';
import '../data/auth_repository.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _registering = false;
  bool _busy = false;
  String? _error;
  String? _message;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final config = ref.read(appConfigProvider);
    if (!config.hasSupabase) return;
    setState(() {
      _busy = true;
      _error = null;
      _message = null;
    });
    try {
      final repository = AuthRepository(Supabase.instance.client);
      final response = _registering
          ? await repository.register(
              email: _email.text.trim(),
              password: _password.text,
            )
          : await repository.signIn(
              email: _email.text.trim(),
              password: _password.text,
            );
      if (!mounted) return;
      if (response.session == null) {
        setState(
          () => _message = 'Check your email to finish account verification.',
        );
      } else {
        context.go('/');
      }
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Authentication failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetPassword() async {
    final config = ref.read(appConfigProvider);
    if (!config.hasSupabase || _email.text.trim().isEmpty) return;
    try {
      await AuthRepository(Supabase.instance.client).sendPasswordReset(
        _email.text.trim(),
        redirectTo: 'pantrymate://auth/reset',
      );
      if (mounted) {
        setState(() => _message = 'Password reset instructions sent.');
      }
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configured = ref.watch(appConfigProvider).hasSupabase;
    return Scaffold(
      appBar: AppBar(title: Text(_registering ? 'Create account' : 'Sign in')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (!configured)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Supabase is not configured. Provide SUPABASE_URL and SUPABASE_ANON_KEY at build time to enable authentication.',
                ),
              ),
            ),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 20),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          if (_message != null) Text(_message!),
          FilledButton(
            onPressed: !configured || _busy ? null : _submit,
            child: _busy
                ? const CircularProgressIndicator()
                : Text(_registering ? 'Register' : 'Sign in'),
          ),
          if (!_registering)
            TextButton(
              onPressed: configured && !_busy ? _resetPassword : null,
              child: const Text('Forgot password?'),
            ),
          TextButton(
            onPressed: _busy
                ? null
                : () => setState(() => _registering = !_registering),
            child: Text(
              _registering
                  ? 'Already have an account? Sign in'
                  : 'Create a new account',
            ),
          ),
        ],
      ),
    );
  }
}
