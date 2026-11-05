import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/app_providers.dart';
import '../../../infrastructure/external_apis/open_food_facts_service.dart';
import '../data/product_repository.dart';
import '../domain/product_models.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final _name = TextEditingController();
  final _barcode = TextEditingController();
  String _category = 'pantry';
  String _unit = 'piece';
  Future<List<Product>>? _products;
  final _favoriteIds = <String>{};
  String? _error;
  bool _saving = false;
  bool _lookingUp = false;

  @override
  void dispose() {
    _name.dispose();
    _barcode.dispose();
    super.dispose();
  }

  Future<void> _load(String householdId) async {
    if (!ref.read(appConfigProvider).hasSupabase) return;
    final repository = ProductRepository(Supabase.instance.client);
    setState(() => _products = repository.list(householdId));
    try {
      final favorites = await repository.listFavoriteProductIds(householdId);
      if (mounted) setState(() => _favoriteIds..addAll(favorites));
    } on PostgrestException catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  Future<void> _setFavorite(String householdId, Product product) async {
    final next = !_favoriteIds.contains(product.id);
    setState(() {
      if (next) {
        _favoriteIds.add(product.id);
      } else {
        _favoriteIds.remove(product.id);
      }
    });
    try {
      await ProductRepository(Supabase.instance.client).setFavorite(
        householdId: householdId,
        productId: product.id,
        favorite: next,
      );
    } on PostgrestException catch (error) {
      if (!mounted) return;
      setState(() {
        if (next) {
          _favoriteIds.remove(product.id);
        } else {
          _favoriteIds.add(product.id);
        }
        _error = error.message;
      });
    }
  }

  Future<void> _save(String householdId) async {
    if (_name.text.trim().isEmpty) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ProductRepository(Supabase.instance.client).create(
        Product(
          id: const Uuid().v4(),
          householdId: householdId,
          name: _name.text.trim(),
          categoryId: _category,
          baseUnit: _unit,
          barcode: _barcode.text.trim().isEmpty ? null : _barcode.text.trim(),
        ),
      );
      _name.clear();
      _barcode.clear();
      await _load(householdId);
    } on PostgrestException catch (error) {
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _lookupBarcode() async {
    setState(() {
      _lookingUp = true;
      _error = null;
    });
    try {
      final metadata = await OpenFoodFactsService().lookup(_barcode.text);
      if (!mounted) return;
      setState(() {
        if (metadata.name != null && metadata.name!.trim().isNotEmpty) {
          _name.text = metadata.name!.trim();
        }
        _barcode.text = metadata.barcode;
      });
    } on ProductLookupException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _lookingUp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final householdId = ref.watch(activeHouseholdIdProvider);
    final configured = ref.watch(appConfigProvider).hasSupabase;
    if (householdId != null && _products == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load(householdId));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: !configured
          ? const Center(child: Text('Configure Supabase to manage products.'))
          : householdId == null
          ? const Center(
              child: Text('Select a household before managing products.'),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Product name'),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _barcode,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Barcode (optional)',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _lookingUp ? null : _lookupBarcode,
                      child: _lookingUp
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Lookup'),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  items: const [
                    DropdownMenuItem(value: 'pantry', child: Text('Pantry')),
                    DropdownMenuItem(value: 'produce', child: Text('Produce')),
                    DropdownMenuItem(value: 'dairy', child: Text('Dairy')),
                    DropdownMenuItem(value: 'frozen', child: Text('Frozen')),
                  ],
                  onChanged: (value) =>
                      setState(() => _category = value ?? _category),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _unit,
                  items: const [
                    DropdownMenuItem(value: 'piece', child: Text('Piece')),
                    DropdownMenuItem(value: 'gram', child: Text('Gram')),
                    DropdownMenuItem(value: 'liter', child: Text('Liter')),
                  ],
                  onChanged: (value) => setState(() => _unit = value ?? _unit),
                  decoration: const InputDecoration(labelText: 'Base unit'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _saving ? null : () => _save(householdId),
                  child: const Text('Add product'),
                ),
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                const Divider(height: 32),
                if (_products == null)
                  const CircularProgressIndicator()
                else
                  FutureBuilder<List<Product>>(
                    future: _products,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          'Unable to load products: ${snapshot.error}',
                        );
                      }
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Text('No products yet.');
                      }
                      return Column(
                        children: snapshot.data!
                            .map(
                              (product) => ListTile(
                                title: Text(product.name),
                                subtitle: Text(
                                  '${product.categoryId} · ${product.baseUnit}',
                                ),
                                trailing: IconButton(
                                  tooltip: _favoriteIds.contains(product.id)
                                      ? 'Remove favorite'
                                      : 'Add favorite',
                                  icon: Icon(
                                    _favoriteIds.contains(product.id)
                                        ? Icons.star
                                        : Icons.star_border,
                                  ),
                                  onPressed: () =>
                                      _setFavorite(householdId, product),
                                ),
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
