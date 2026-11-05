import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/app_providers.dart';
import '../data/feedback_repository.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final _message = TextEditingController();
  String _category = 'feedback';
  bool _sending = false;
  String? _status;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final config = ref.read(appConfigProvider);
    if (!config.hasSupabase ||
        Supabase.instance.client.auth.currentUser == null) {
      setState(() => _status = 'Sign in before submitting feedback.');
      return;
    }
    final message = _message.text.trim();
    if (message.isEmpty || message.length > 5000) {
      setState(
        () => _status = 'Enter a message between 1 and 5000 characters.',
      );
      return;
    }
    setState(() {
      _sending = true;
      _status = null;
    });
    try {
      await FeedbackRepository(
        Supabase.instance.client,
      ).submit(category: _category, message: message);
      if (mounted) {
        _message.clear();
        setState(() => _status = 'Feedback submitted. Thank you.');
      }
    } on PostgrestException catch (error) {
      if (mounted) setState(() => _status = error.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help and feedback')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Tell us what would make PantryMate better.'),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _category,
            items: const [
              DropdownMenuItem(value: 'feedback', child: Text('Feedback')),
              DropdownMenuItem(value: 'bug', child: Text('Bug report')),
              DropdownMenuItem(value: 'help', child: Text('Help request')),
            ],
            onChanged: (value) =>
                setState(() => _category = value ?? _category),
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _message,
            maxLines: 7,
            maxLength: 5000,
            decoration: const InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _sending ? null : _submit,
            child: Text(_sending ? 'Submitting…' : 'Submit feedback'),
          ),
          if (_status != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(_status!),
            ),
        ],
      ),
    );
  }
}
