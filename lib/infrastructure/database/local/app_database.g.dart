// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUnitMeta = const VerificationMeta(
    'baseUnit',
  );
  @override
  late final GeneratedColumn<String> baseUnit = GeneratedColumn<String>(
    'base_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    name,
    categoryId,
    baseUnit,
    barcode,
    brand,
    notes,
    archived,
    revision,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('base_unit')) {
      context.handle(
        _baseUnitMeta,
        baseUnit.isAcceptableOrUnknown(data['base_unit']!, _baseUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUnitMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      baseUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_unit'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String householdId;
  final String name;
  final String categoryId;
  final String baseUnit;
  final String? barcode;
  final String? brand;
  final String? notes;
  final bool archived;
  final int revision;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.householdId,
    required this.name,
    required this.categoryId,
    required this.baseUnit,
    this.barcode,
    this.brand,
    this.notes,
    required this.archived,
    required this.revision,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<String>(categoryId);
    map['base_unit'] = Variable<String>(baseUnit);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['archived'] = Variable<bool>(archived);
    map['revision'] = Variable<int>(revision);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      categoryId: Value(categoryId),
      baseUnit: Value(baseUnit),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      archived: Value(archived),
      revision: Value(revision),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      baseUnit: serializer.fromJson<String>(json['baseUnit']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      brand: serializer.fromJson<String?>(json['brand']),
      notes: serializer.fromJson<String?>(json['notes']),
      archived: serializer.fromJson<bool>(json['archived']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String>(categoryId),
      'baseUnit': serializer.toJson<String>(baseUnit),
      'barcode': serializer.toJson<String?>(barcode),
      'brand': serializer.toJson<String?>(brand),
      'notes': serializer.toJson<String?>(notes),
      'archived': serializer.toJson<bool>(archived),
      'revision': serializer.toJson<int>(revision),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    String? id,
    String? householdId,
    String? name,
    String? categoryId,
    String? baseUnit,
    Value<String?> barcode = const Value.absent(),
    Value<String?> brand = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? archived,
    int? revision,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    name: name ?? this.name,
    categoryId: categoryId ?? this.categoryId,
    baseUnit: baseUnit ?? this.baseUnit,
    barcode: barcode.present ? barcode.value : this.barcode,
    brand: brand.present ? brand.value : this.brand,
    notes: notes.present ? notes.value : this.notes,
    archived: archived ?? this.archived,
    revision: revision ?? this.revision,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      baseUnit: data.baseUnit.present ? data.baseUnit.value : this.baseUnit,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      brand: data.brand.present ? data.brand.value : this.brand,
      notes: data.notes.present ? data.notes.value : this.notes,
      archived: data.archived.present ? data.archived.value : this.archived,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('baseUnit: $baseUnit, ')
          ..write('barcode: $barcode, ')
          ..write('brand: $brand, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('revision: $revision, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    name,
    categoryId,
    baseUnit,
    barcode,
    brand,
    notes,
    archived,
    revision,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.baseUnit == this.baseUnit &&
          other.barcode == this.barcode &&
          other.brand == this.brand &&
          other.notes == this.notes &&
          other.archived == this.archived &&
          other.revision == this.revision &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> name;
  final Value<String> categoryId;
  final Value<String> baseUnit;
  final Value<String?> barcode;
  final Value<String?> brand;
  final Value<String?> notes;
  final Value<bool> archived;
  final Value<int> revision;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.baseUnit = const Value.absent(),
    this.barcode = const Value.absent(),
    this.brand = const Value.absent(),
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String householdId,
    required String name,
    required String categoryId,
    required String baseUnit,
    this.barcode = const Value.absent(),
    this.brand = const Value.absent(),
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.revision = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       name = Value(name),
       categoryId = Value(categoryId),
       baseUnit = Value(baseUnit),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<String>? baseUnit,
    Expression<String>? barcode,
    Expression<String>? brand,
    Expression<String>? notes,
    Expression<bool>? archived,
    Expression<int>? revision,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (baseUnit != null) 'base_unit': baseUnit,
      if (barcode != null) 'barcode': barcode,
      if (brand != null) 'brand': brand,
      if (notes != null) 'notes': notes,
      if (archived != null) 'archived': archived,
      if (revision != null) 'revision': revision,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? name,
    Value<String>? categoryId,
    Value<String>? baseUnit,
    Value<String?>? barcode,
    Value<String?>? brand,
    Value<String?>? notes,
    Value<bool>? archived,
    Value<int>? revision,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      baseUnit: baseUnit ?? this.baseUnit,
      barcode: barcode ?? this.barcode,
      brand: brand ?? this.brand,
      notes: notes ?? this.notes,
      archived: archived ?? this.archived,
      revision: revision ?? this.revision,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (baseUnit.present) {
      map['base_unit'] = Variable<String>(baseUnit.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('baseUnit: $baseUnit, ')
          ..write('barcode: $barcode, ')
          ..write('brand: $brand, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('revision: $revision, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryBatchesTable extends InventoryBatches
    with TableInfo<$InventoryBatchesTable, InventoryBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresOnMeta = const VerificationMeta(
    'expiresOn',
  );
  @override
  late final GeneratedColumn<DateTime> expiresOn = GeneratedColumn<DateTime>(
    'expires_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    productId,
    quantity,
    unit,
    locationId,
    expiresOn,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryBatche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('expires_on')) {
      context.handle(
        _expiresOnMeta,
        expiresOn.isAcceptableOrUnknown(data['expires_on']!, _expiresOnMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryBatche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      )!,
      expiresOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_on'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InventoryBatchesTable createAlias(String alias) {
    return $InventoryBatchesTable(attachedDatabase, alias);
  }
}

class InventoryBatche extends DataClass implements Insertable<InventoryBatche> {
  final String id;
  final String householdId;
  final String productId;
  final double quantity;
  final String unit;
  final String locationId;
  final DateTime? expiresOn;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const InventoryBatche({
    required this.id,
    required this.householdId,
    required this.productId,
    required this.quantity,
    required this.unit,
    required this.locationId,
    this.expiresOn,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['location_id'] = Variable<String>(locationId);
    if (!nullToAbsent || expiresOn != null) {
      map['expires_on'] = Variable<DateTime>(expiresOn);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InventoryBatchesCompanion toCompanion(bool nullToAbsent) {
    return InventoryBatchesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      productId: Value(productId),
      quantity: Value(quantity),
      unit: Value(unit),
      locationId: Value(locationId),
      expiresOn: expiresOn == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresOn),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InventoryBatche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryBatche(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      locationId: serializer.fromJson<String>(json['locationId']),
      expiresOn: serializer.fromJson<DateTime?>(json['expiresOn']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'locationId': serializer.toJson<String>(locationId),
      'expiresOn': serializer.toJson<DateTime?>(expiresOn),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InventoryBatche copyWith({
    String? id,
    String? householdId,
    String? productId,
    double? quantity,
    String? unit,
    String? locationId,
    Value<DateTime?> expiresOn = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => InventoryBatche(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    locationId: locationId ?? this.locationId,
    expiresOn: expiresOn.present ? expiresOn.value : this.expiresOn,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InventoryBatche copyWithCompanion(InventoryBatchesCompanion data) {
    return InventoryBatche(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      expiresOn: data.expiresOn.present ? data.expiresOn.value : this.expiresOn,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBatche(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('locationId: $locationId, ')
          ..write('expiresOn: $expiresOn, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    productId,
    quantity,
    unit,
    locationId,
    expiresOn,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryBatche &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.locationId == this.locationId &&
          other.expiresOn == this.expiresOn &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InventoryBatchesCompanion extends UpdateCompanion<InventoryBatche> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> productId;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<String> locationId;
  final Value<DateTime?> expiresOn;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InventoryBatchesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.locationId = const Value.absent(),
    this.expiresOn = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryBatchesCompanion.insert({
    required String id,
    required String householdId,
    required String productId,
    required double quantity,
    required String unit,
    required String locationId,
    this.expiresOn = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       productId = Value(productId),
       quantity = Value(quantity),
       unit = Value(unit),
       locationId = Value(locationId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InventoryBatche> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? productId,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? locationId,
    Expression<DateTime>? expiresOn,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (locationId != null) 'location_id': locationId,
      if (expiresOn != null) 'expires_on': expiresOn,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryBatchesCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? productId,
    Value<double>? quantity,
    Value<String>? unit,
    Value<String>? locationId,
    Value<DateTime?>? expiresOn,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InventoryBatchesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      locationId: locationId ?? this.locationId,
      expiresOn: expiresOn ?? this.expiresOn,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (expiresOn.present) {
      map['expires_on'] = Variable<DateTime>(expiresOn.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBatchesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('locationId: $locationId, ')
          ..write('expiresOn: $expiresOn, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxOperationsTable extends OutboxOperations
    with TableInfo<$OutboxOperationsTable, OutboxOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    userId,
    householdId,
    entityType,
    entityId,
    operationType,
    payload,
    status,
    attemptCount,
    createdAt,
    nextAttemptAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  OutboxOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxOperation(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $OutboxOperationsTable createAlias(String alias) {
    return $OutboxOperationsTable(attachedDatabase, alias);
  }
}

class OutboxOperation extends DataClass implements Insertable<OutboxOperation> {
  final String operationId;
  final String userId;
  final String householdId;
  final String entityType;
  final String entityId;
  final String operationType;
  final String payload;
  final String status;
  final int attemptCount;
  final DateTime createdAt;
  final DateTime? nextAttemptAt;
  final String? lastError;
  const OutboxOperation({
    required this.operationId,
    required this.userId,
    required this.householdId,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.payload,
    required this.status,
    required this.attemptCount,
    required this.createdAt,
    this.nextAttemptAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['user_id'] = Variable<String>(userId);
    map['household_id'] = Variable<String>(householdId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation_type'] = Variable<String>(operationType);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['attempt_count'] = Variable<int>(attemptCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  OutboxOperationsCompanion toCompanion(bool nullToAbsent) {
    return OutboxOperationsCompanion(
      operationId: Value(operationId),
      userId: Value(userId),
      householdId: Value(householdId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operationType: Value(operationType),
      payload: Value(payload),
      status: Value(status),
      attemptCount: Value(attemptCount),
      createdAt: Value(createdAt),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory OutboxOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxOperation(
      operationId: serializer.fromJson<String>(json['operationId']),
      userId: serializer.fromJson<String>(json['userId']),
      householdId: serializer.fromJson<String>(json['householdId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'userId': serializer.toJson<String>(userId),
      'householdId': serializer.toJson<String>(householdId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operationType': serializer.toJson<String>(operationType),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  OutboxOperation copyWith({
    String? operationId,
    String? userId,
    String? householdId,
    String? entityType,
    String? entityId,
    String? operationType,
    String? payload,
    String? status,
    int? attemptCount,
    DateTime? createdAt,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
  }) => OutboxOperation(
    operationId: operationId ?? this.operationId,
    userId: userId ?? this.userId,
    householdId: householdId ?? this.householdId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operationType: operationType ?? this.operationType,
    payload: payload ?? this.payload,
    status: status ?? this.status,
    attemptCount: attemptCount ?? this.attemptCount,
    createdAt: createdAt ?? this.createdAt,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  OutboxOperation copyWithCompanion(OutboxOperationsCompanion data) {
    return OutboxOperation(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      userId: data.userId.present ? data.userId.value : this.userId,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxOperation(')
          ..write('operationId: $operationId, ')
          ..write('userId: $userId, ')
          ..write('householdId: $householdId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    userId,
    householdId,
    entityType,
    entityId,
    operationType,
    payload,
    status,
    attemptCount,
    createdAt,
    nextAttemptAt,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxOperation &&
          other.operationId == this.operationId &&
          other.userId == this.userId &&
          other.householdId == this.householdId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operationType == this.operationType &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.attemptCount == this.attemptCount &&
          other.createdAt == this.createdAt &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError);
}

class OutboxOperationsCompanion extends UpdateCompanion<OutboxOperation> {
  final Value<String> operationId;
  final Value<String> userId;
  final Value<String> householdId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operationType;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> attemptCount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<int> rowid;
  const OutboxOperationsCompanion({
    this.operationId = const Value.absent(),
    this.userId = const Value.absent(),
    this.householdId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxOperationsCompanion.insert({
    required String operationId,
    required String userId,
    required String householdId,
    required String entityType,
    required String entityId,
    required String operationType,
    required String payload,
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    required DateTime createdAt,
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       userId = Value(userId),
       householdId = Value(householdId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operationType = Value(operationType),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OutboxOperation> custom({
    Expression<String>? operationId,
    Expression<String>? userId,
    Expression<String>? householdId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operationType,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? attemptCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (userId != null) 'user_id': userId,
      if (householdId != null) 'household_id': householdId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operationType != null) 'operation_type': operationType,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (createdAt != null) 'created_at': createdAt,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxOperationsCompanion copyWith({
    Value<String>? operationId,
    Value<String>? userId,
    Value<String>? householdId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operationType,
    Value<String>? payload,
    Value<String>? status,
    Value<int>? attemptCount,
    Value<DateTime>? createdAt,
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return OutboxOperationsCompanion(
      operationId: operationId ?? this.operationId,
      userId: userId ?? this.userId,
      householdId: householdId ?? this.householdId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      createdAt: createdAt ?? this.createdAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxOperationsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('userId: $userId, ')
          ..write('householdId: $householdId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastServerRevisionMeta =
      const VerificationMeta('lastServerRevision');
  @override
  late final GeneratedColumn<int> lastServerRevision = GeneratedColumn<int>(
    'last_server_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    householdId,
    lastServerRevision,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('last_server_revision')) {
      context.handle(
        _lastServerRevisionMeta,
        lastServerRevision.isAcceptableOrUnknown(
          data['last_server_revision']!,
          _lastServerRevisionMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, householdId};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      lastServerRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_server_revision'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String userId;
  final String householdId;
  final int lastServerRevision;
  final DateTime? syncedAt;
  const SyncMetadataData({
    required this.userId,
    required this.householdId,
    required this.lastServerRevision,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['household_id'] = Variable<String>(householdId);
    map['last_server_revision'] = Variable<int>(lastServerRevision);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      userId: Value(userId),
      householdId: Value(householdId),
      lastServerRevision: Value(lastServerRevision),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SyncMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      userId: serializer.fromJson<String>(json['userId']),
      householdId: serializer.fromJson<String>(json['householdId']),
      lastServerRevision: serializer.fromJson<int>(json['lastServerRevision']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'householdId': serializer.toJson<String>(householdId),
      'lastServerRevision': serializer.toJson<int>(lastServerRevision),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SyncMetadataData copyWith({
    String? userId,
    String? householdId,
    int? lastServerRevision,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => SyncMetadataData(
    userId: userId ?? this.userId,
    householdId: householdId ?? this.householdId,
    lastServerRevision: lastServerRevision ?? this.lastServerRevision,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      userId: data.userId.present ? data.userId.value : this.userId,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      lastServerRevision: data.lastServerRevision.present
          ? data.lastServerRevision.value
          : this.lastServerRevision,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('userId: $userId, ')
          ..write('householdId: $householdId, ')
          ..write('lastServerRevision: $lastServerRevision, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, householdId, lastServerRevision, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.userId == this.userId &&
          other.householdId == this.householdId &&
          other.lastServerRevision == this.lastServerRevision &&
          other.syncedAt == this.syncedAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> userId;
  final Value<String> householdId;
  final Value<int> lastServerRevision;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.userId = const Value.absent(),
    this.householdId = const Value.absent(),
    this.lastServerRevision = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String userId,
    required String householdId,
    this.lastServerRevision = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       householdId = Value(householdId);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? userId,
    Expression<String>? householdId,
    Expression<int>? lastServerRevision,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (householdId != null) 'household_id': householdId,
      if (lastServerRevision != null)
        'last_server_revision': lastServerRevision,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? userId,
    Value<String>? householdId,
    Value<int>? lastServerRevision,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      userId: userId ?? this.userId,
      householdId: householdId ?? this.householdId,
      lastServerRevision: lastServerRevision ?? this.lastServerRevision,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (lastServerRevision.present) {
      map['last_server_revision'] = Variable<int>(lastServerRevision.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('userId: $userId, ')
          ..write('householdId: $householdId, ')
          ..write('lastServerRevision: $lastServerRevision, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $InventoryBatchesTable inventoryBatches = $InventoryBatchesTable(
    this,
  );
  late final $OutboxOperationsTable outboxOperations = $OutboxOperationsTable(
    this,
  );
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    inventoryBatches,
    outboxOperations,
    syncMetadata,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String householdId,
      required String name,
      required String categoryId,
      required String baseUnit,
      Value<String?> barcode,
      Value<String?> brand,
      Value<String?> notes,
      Value<bool> archived,
      Value<int> revision,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> name,
      Value<String> categoryId,
      Value<String> baseUnit,
      Value<String?> barcode,
      Value<String?> brand,
      Value<String?> notes,
      Value<bool> archived,
      Value<int> revision,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUnit => $composableBuilder(
    column: $table.baseUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUnit => $composableBuilder(
    column: $table.baseUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseUnit =>
      $composableBuilder(column: $table.baseUnit, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> baseUnit = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                householdId: householdId,
                name: name,
                categoryId: categoryId,
                baseUnit: baseUnit,
                barcode: barcode,
                brand: brand,
                notes: notes,
                archived: archived,
                revision: revision,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String name,
                required String categoryId,
                required String baseUnit,
                Value<String?> barcode = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> revision = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                householdId: householdId,
                name: name,
                categoryId: categoryId,
                baseUnit: baseUnit,
                barcode: barcode,
                brand: brand,
                notes: notes,
                archived: archived,
                revision: revision,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$InventoryBatchesTableCreateCompanionBuilder =
    InventoryBatchesCompanion Function({
      required String id,
      required String householdId,
      required String productId,
      required double quantity,
      required String unit,
      required String locationId,
      Value<DateTime?> expiresOn,
      Value<bool> archived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$InventoryBatchesTableUpdateCompanionBuilder =
    InventoryBatchesCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> productId,
      Value<double> quantity,
      Value<String> unit,
      Value<String> locationId,
      Value<DateTime?> expiresOn,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$InventoryBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryBatchesTable> {
  $$InventoryBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresOn => $composableBuilder(
    column: $table.expiresOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryBatchesTable> {
  $$InventoryBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresOn => $composableBuilder(
    column: $table.expiresOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryBatchesTable> {
  $$InventoryBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresOn =>
      $composableBuilder(column: $table.expiresOn, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InventoryBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryBatchesTable,
          InventoryBatche,
          $$InventoryBatchesTableFilterComposer,
          $$InventoryBatchesTableOrderingComposer,
          $$InventoryBatchesTableAnnotationComposer,
          $$InventoryBatchesTableCreateCompanionBuilder,
          $$InventoryBatchesTableUpdateCompanionBuilder,
          (
            InventoryBatche,
            BaseReferences<
              _$AppDatabase,
              $InventoryBatchesTable,
              InventoryBatche
            >,
          ),
          InventoryBatche,
          PrefetchHooks Function()
        > {
  $$InventoryBatchesTableTableManager(
    _$AppDatabase db,
    $InventoryBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> locationId = const Value.absent(),
                Value<DateTime?> expiresOn = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryBatchesCompanion(
                id: id,
                householdId: householdId,
                productId: productId,
                quantity: quantity,
                unit: unit,
                locationId: locationId,
                expiresOn: expiresOn,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String productId,
                required double quantity,
                required String unit,
                required String locationId,
                Value<DateTime?> expiresOn = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InventoryBatchesCompanion.insert(
                id: id,
                householdId: householdId,
                productId: productId,
                quantity: quantity,
                unit: unit,
                locationId: locationId,
                expiresOn: expiresOn,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryBatchesTable,
      InventoryBatche,
      $$InventoryBatchesTableFilterComposer,
      $$InventoryBatchesTableOrderingComposer,
      $$InventoryBatchesTableAnnotationComposer,
      $$InventoryBatchesTableCreateCompanionBuilder,
      $$InventoryBatchesTableUpdateCompanionBuilder,
      (
        InventoryBatche,
        BaseReferences<_$AppDatabase, $InventoryBatchesTable, InventoryBatche>,
      ),
      InventoryBatche,
      PrefetchHooks Function()
    >;
typedef $$OutboxOperationsTableCreateCompanionBuilder =
    OutboxOperationsCompanion Function({
      required String operationId,
      required String userId,
      required String householdId,
      required String entityType,
      required String entityId,
      required String operationType,
      required String payload,
      Value<String> status,
      Value<int> attemptCount,
      required DateTime createdAt,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$OutboxOperationsTableUpdateCompanionBuilder =
    OutboxOperationsCompanion Function({
      Value<String> operationId,
      Value<String> userId,
      Value<String> householdId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operationType,
      Value<String> payload,
      Value<String> status,
      Value<int> attemptCount,
      Value<DateTime> createdAt,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$OutboxOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxOperationsTable> {
  $$OutboxOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxOperationsTable> {
  $$OutboxOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxOperationsTable> {
  $$OutboxOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$OutboxOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxOperationsTable,
          OutboxOperation,
          $$OutboxOperationsTableFilterComposer,
          $$OutboxOperationsTableOrderingComposer,
          $$OutboxOperationsTableAnnotationComposer,
          $$OutboxOperationsTableCreateCompanionBuilder,
          $$OutboxOperationsTableUpdateCompanionBuilder,
          (
            OutboxOperation,
            BaseReferences<
              _$AppDatabase,
              $OutboxOperationsTable,
              OutboxOperation
            >,
          ),
          OutboxOperation,
          PrefetchHooks Function()
        > {
  $$OutboxOperationsTableTableManager(
    _$AppDatabase db,
    $OutboxOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxOperationsCompanion(
                operationId: operationId,
                userId: userId,
                householdId: householdId,
                entityType: entityType,
                entityId: entityId,
                operationType: operationType,
                payload: payload,
                status: status,
                attemptCount: attemptCount,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String userId,
                required String householdId,
                required String entityType,
                required String entityId,
                required String operationType,
                required String payload,
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxOperationsCompanion.insert(
                operationId: operationId,
                userId: userId,
                householdId: householdId,
                entityType: entityType,
                entityId: entityId,
                operationType: operationType,
                payload: payload,
                status: status,
                attemptCount: attemptCount,
                createdAt: createdAt,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxOperationsTable,
      OutboxOperation,
      $$OutboxOperationsTableFilterComposer,
      $$OutboxOperationsTableOrderingComposer,
      $$OutboxOperationsTableAnnotationComposer,
      $$OutboxOperationsTableCreateCompanionBuilder,
      $$OutboxOperationsTableUpdateCompanionBuilder,
      (
        OutboxOperation,
        BaseReferences<_$AppDatabase, $OutboxOperationsTable, OutboxOperation>,
      ),
      OutboxOperation,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String userId,
      required String householdId,
      Value<int> lastServerRevision,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> userId,
      Value<String> householdId,
      Value<int> lastServerRevision,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastServerRevision => $composableBuilder(
    column: $table.lastServerRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastServerRevision => $composableBuilder(
    column: $table.lastServerRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
    column: $table.householdId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastServerRevision => $composableBuilder(
    column: $table.lastServerRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadataData,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataData,
            BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
          ),
          SyncMetadataData,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<int> lastServerRevision = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(
                userId: userId,
                householdId: householdId,
                lastServerRevision: lastServerRevision,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String householdId,
                Value<int> lastServerRevision = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                userId: userId,
                householdId: householdId,
                lastServerRevision: lastServerRevision,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadataData,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataData,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
      ),
      SyncMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$InventoryBatchesTableTableManager get inventoryBatches =>
      $$InventoryBatchesTableTableManager(_db, _db.inventoryBatches);
  $$OutboxOperationsTableTableManager get outboxOperations =>
      $$OutboxOperationsTableTableManager(_db, _db.outboxOperations);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
