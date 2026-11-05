import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/app_providers.dart';
import '../data/shopping_repository.dart';
import '../domain/shopping_models.dart';

class ShoppingPage extends ConsumerStatefulWidget {
  const ShoppingPage({super.key});

  @override
  ConsumerState<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends ConsumerState<ShoppingPage> {
  final _listName = TextEditingController();
  final _itemName = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  List<ShoppingList> _lists = const [];
  ShoppingList? _selected;
  List<ShoppingItem> _items = const [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _listName.dispose();
    _itemName.dispose();
    _quantity.dispose();
    super.dispose();
  }

  ShoppingRepository? _repository() {
    if (!ref.read(appConfigProvider).hasSupabase) return null;
    return ShoppingRepository(Supabase.instance.client);
  }

  Future<void> _load(String householdId) async {
    final repository = _repository();
    if (repository == null) return;
    setState(() => _loading = true);
    try {
      _lists = await repository.lists(householdId);
      _selected = _lists.isEmpty ? null : _selected ?? _lists.first;
      _items = _selected == null
          ? const []
          : await repository.items(_selected!.id);
    } on PostgrestException catch (error) {
      _error = error.message;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createList(String householdId) async {
    final repository = _repository();
    if (repository == null || _listName.text.trim().isEmpty) return;
    await repository.createList(
      householdId: householdId,
      name: _listName.text.trim(),
    );
    _listName.clear();
    await _load(householdId);
  }

  Future<void> _addItem(String householdId) async {
    final repository = _repository();
    final quantity = num.tryParse(_quantity.text.trim());
    if (repository == null ||
        _selected == null ||
        _itemName.text.trim().isEmpty ||
        quantity == null ||
        quantity <= 0) {
      return;
    }
    await repository.addItem(
      householdId: householdId,
      listId: _selected!.id,
      name: _itemName.text.trim(),
      quantity: quantity,
      unit: 'piece',
    );
    _itemName.clear();
    await _load(householdId);
  }

  Future<void> _purchase(String householdId, ShoppingItem item) async {
    final locationController = TextEditingController();
    final locationId = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase item'),
        content: TextField(
          controller: locationController,
          decoration: const InputDecoration(labelText: 'Storage location ID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, locationController.text.trim()),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    locationController.dispose();
    if (locationId == null || locationId.isEmpty) return;
    final repository = _repository();
    if (repository == null) return;
    try {
      await repository.purchaseItem(
        itemId: item.id,
        quantity: item.quantity,
        unit: item.unit,
        locationId: locationId,
      );
      await _load(householdId);
    } on PostgrestException catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final householdId = ref.watch(activeHouseholdIdProvider);
    final configured = ref.watch(appConfigProvider).hasSupabase;
    if (householdId != null && _lists.isEmpty && !_loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load(householdId));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping')),
      body: !configured
          ? const Center(
              child: Text('Configure Supabase to manage shopping lists.'),
            )
          : householdId == null
          ? const Center(
              child: Text('Select a household before managing shopping.'),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextField(
                  controller: _listName,
                  decoration: const InputDecoration(labelText: 'New list name'),
                ),
                FilledButton(
                  onPressed: _loading ? null : () => _createList(householdId),
                  child: const Text('Create list'),
                ),
                if (_lists.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _selected?.id,
                    items: _lists
                        .map(
                          (list) => DropdownMenuItem(
                            value: list.id,
                            child: Text(list.name),
                          ),
                        )
                        .toList(),
                    onChanged: (id) async {
                      _selected = _lists.firstWhere((list) => list.id == id);
                      await _load(householdId);
                    },
                    decoration: const InputDecoration(labelText: 'Active list'),
                  ),
                if (_selected != null) ...[
                  TextField(
                    controller: _itemName,
                    decoration: const InputDecoration(labelText: 'Item'),
                  ),
                  TextField(
                    controller: _quantity,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                  FilledButton(
                    onPressed: _loading ? null : () => _addItem(householdId),
                    child: const Text('Add item'),
                  ),
                ],
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                const Divider(height: 32),
                if (_loading) const CircularProgressIndicator(),
                if (!_loading && _selected == null)
                  const Text('Create a list to begin shopping.'),
                ..._items.map(
                  (item) => ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      '${item.quantity} ${item.unit} · ${item.priority}',
                    ),
                    trailing: item.purchasedAt == null
                        ? IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () => _purchase(householdId, item),
                          )
                        : const Icon(Icons.check),
                  ),
                ),
              ],
            ),
    );
  }
}
