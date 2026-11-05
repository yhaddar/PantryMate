import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/app_providers.dart';

class AddInventoryPage extends ConsumerStatefulWidget {
  const AddInventoryPage({super.key});

  @override
  ConsumerState<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends ConsumerState<AddInventoryPage> {
  final _productId = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _locationId = TextEditingController();
  String _unit = 'piece';
  DateTime? _expiresOn;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _productId.dispose();
    _quantity.dispose();
    _locationId.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final householdId = ref.read(activeHouseholdIdProvider);
    final config = ref.read(appConfigProvider);
    final user = config.hasSupabase
        ? Supabase.instance.client.auth.currentUser
        : null;
    final quantity = num.tryParse(_quantity.text.trim());
    if (householdId == null || user == null) {
      setState(
        () =>
            _error = 'Sign in and select a household before adding inventory.',
      );
      return;
    }
    if (_productId.text.trim().isEmpty ||
        _locationId.text.trim().isEmpty ||
        quantity == null ||
        quantity <= 0) {
      setState(
        () =>
            _error = 'Enter a product ID, location ID, and positive quantity.',
      );
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(localInventoryRepositoryProvider)
          .addBatch(
            userId: user.id,
            householdId: householdId,
            productId: _productId.text.trim(),
            quantity: quantity,
            unit: _unit,
            locationId: _locationId.text.trim(),
            expiresOn: _expiresOn,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Inventory could not be saved locally. Please retry.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add inventory')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _productId,
            decoration: const InputDecoration(labelText: 'Product ID'),
          ),
          TextField(
            controller: _quantity,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          DropdownButtonFormField<String>(
            initialValue: _unit,
            items: const [
              DropdownMenuItem(value: 'piece', child: Text('Piece')),
              DropdownMenuItem(value: 'gram', child: Text('Gram')),
              DropdownMenuItem(value: 'liter', child: Text('Liter')),
            ],
            onChanged: (value) => setState(() => _unit = value ?? _unit),
            decoration: const InputDecoration(labelText: 'Unit'),
          ),
          TextField(
            controller: _locationId,
            decoration: const InputDecoration(labelText: 'Storage location ID'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final selected = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                initialDate: DateTime.now(),
              );
              if (selected != null) setState(() => _expiresOn = selected);
            },
            icon: const Icon(Icons.event_outlined),
            label: Text(
              _expiresOn == null
                  ? 'Optional expiration date'
                  : 'Expires ${_expiresOn!.year}-${_expiresOn!.month}-${_expiresOn!.day}',
            ),
          ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving locally…' : 'Save inventory'),
          ),
        ],
      ),
    );
  }
}
