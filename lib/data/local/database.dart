import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ---- User data (permanent) -------------------------------------------------

class Favorites extends Table {
  TextColumn get symbol => text()();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {symbol};
}

class Simulations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();
  TextColumn get title => text()();
  TextColumn get payload => text()(); // JSON map
  DateTimeColumn get createdAt => dateTime()();
}

class Preferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Single-row table (id = 1).
class QuizStatsRows extends Table {
  IntColumn get id => integer()();
  IntColumn get correct => integer().withDefault(const Constant(0))();
  IntColumn get answered => integer().withDefault(const Constant(0))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  IntColumn get bestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPlayed => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---- API cache (can be downloaded again) -------------------------------------

class CachedPrices extends Table {
  TextColumn get symbol => text()();
  TextColumn get granularity => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get close => real()();

  @override
  Set<Column> get primaryKey => {symbol, granularity, date};
}

class CacheMeta extends Table {
  TextColumn get symbol => text()();
  TextColumn get granularity => text()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {symbol, granularity};
}

@DriftDatabase(
  tables: [
    Favorites,
    Simulations,
    Preferences,
    QuizStatsRows,
    CachedPrices,
    CacheMeta,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'boussole'));

  @override
  int get schemaVersion => 1;
}
