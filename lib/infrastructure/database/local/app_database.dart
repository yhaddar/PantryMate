import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get name => text()();
  TextColumn get categoryId => text()();
  TextColumn get baseUnit => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get brand => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class InventoryBatches extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get productId => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  TextColumn get locationId => text()();
  DateTimeColumn get expiresOn => dateTime().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class OutboxOperations extends Table {
  TextColumn get operationId => text()();
  TextColumn get userId => text()();
  TextColumn get householdId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operationType => text()();
  TextColumn get payload => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {operationId};
}

class SyncMetadata extends Table {
  TextColumn get userId => text()();
  TextColumn get householdId => text()();
  IntColumn get lastServerRevision =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {userId, householdId};
}

@DriftDatabase(
  tables: [Products, InventoryBatches, OutboxOperations, SyncMetadata],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'pantry_mate'));

  @override
  int get schemaVersion => 1;

  Future<List<Product>> productsForHousehold(String householdId) {
    return (select(products)
          ..where(
            (row) =>
                row.householdId.equals(householdId) &
                row.archived.equals(false),
          )
          ..orderBy([(row) => OrderingTerm(expression: row.name)]))
        .get();
  }

  Future<void> enqueue(OutboxOperationsCompanion operation) async {
    await into(outboxOperations).insertOnConflictUpdate(operation);
  }
}
