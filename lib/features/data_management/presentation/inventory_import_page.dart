import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/app_providers.dart';
import '../../data_management/domain/inventory_import.dart';
import '../../reports/data/csv_inventory_codec.dart';

class InventoryImportPage extends ConsumerStatefulWidget {
  const InventoryImportPage({super.key});

  @override
  ConsumerState<InventoryImportPage> createState() =>
      _InventoryImportPageState();
}

class _InventoryImportPageState extends ConsumerState<InventoryImportPage> {
  InventoryImportPreview? _preview;
  bool _working = false;
  String? _message;

  Future<void> _chooseFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
    );
    if (file == null) return;
    try {
      final text = utf8.decode(await file.readAsBytes());
      final preview = const InventoryImportValidator(
        InventoryCsvCodec(),
      ).preview(text);
      setState(() {
        _preview = preview;
        _message = null;
      });
    } catch (_) {
      setState(() => _message = 'The selected CSV file could not be read.');
    }
  }

  Future<void> _apply() async {
    final preview = _preview;
    final householdId = ref.read(activeHouseholdIdProvider);
    final user = Supabase.instance.client.auth.currentUser;
    if (preview == null ||
        !preview.canApply ||
        householdId == null ||
        user == null) {
      setState(
        () => _message =
            'Sign in, select a household, and resolve all import errors.',
      );
      return;
    }
    setState(() {
      _working = true;
      _message = null;
    });
    try {
      await ref
          .read(localInventoryRepositoryProvider)
          .importBatches(
            userId: user.id,
            householdId: householdId,
            rows: preview.validRows,
          );
      if (mounted) {
        setState(() {
          _preview = null;
          _message =
              'Inventory imported locally and queued for synchronization.';
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _message = 'Import was not applied: $error');
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final householdId = ref.watch(activeHouseholdIdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Import inventory')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Choose a CSV with product, quantity, unit, expires_on, location columns.',
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _working ? null : _chooseFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('Choose CSV'),
          ),
          if (_preview case final preview?) ...[
            Text(
              '${preview.validRows.length} valid rows · ${preview.errors.length} errors',
            ),
            ...preview.errors.map(
              (error) => ListTile(
                leading: const Icon(Icons.error_outline),
                title: Text('Row ${error.row}'),
                subtitle: Text(error.message),
              ),
            ),
            if (preview.canApply)
              FilledButton(
                onPressed: _working || householdId == null ? null : _apply,
                child: Text(_working ? 'Importing…' : 'Apply import'),
              ),
          ],
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_message!),
            ),
        ],
      ),
    );
  }
}
