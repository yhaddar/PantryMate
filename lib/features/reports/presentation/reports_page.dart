import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/providers/app_providers.dart';
import '../data/pdf_report_service.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  bool _generating = false;
  String? _message;

  Future<void> _generate() async {
    final householdId = ref.read(activeHouseholdIdProvider);
    if (householdId == null) {
      setState(
        () => _message = 'Select a household before generating a report.',
      );
      return;
    }
    setState(() {
      _generating = true;
      _message = null;
    });
    try {
      final summary = await ref
          .read(localDashboardRepositoryProvider)
          .load(householdId);
      final bytes = await PdfReportService().generateDashboardSummary(
        summary,
        generatedAt: DateTime.now(),
      );
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/pantrymate-report-${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(bytes, flush: true);
      if (mounted) {
        setState(
          () =>
              _message = 'PDF snapshot saved locally (${bytes.length} bytes).',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _message = 'Unable to generate the local report snapshot.',
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reports use a consistent local snapshot.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _generating ? null : _generate,
              child: Text(_generating ? 'Generating…' : 'Generate PDF summary'),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(_message!),
              ),
          ],
        ),
      ),
    );
  }
}
