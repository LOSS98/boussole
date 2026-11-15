import 'package:drift/drift.dart';

import '../../domain/models/price_point.dart';
import 'database.dart';

class CacheMetaInfo {
  const CacheMetaInfo(this.fetchedAt);
  final DateTime fetchedAt;
}

/// Persistence of API data (can always be downloaded again).
class PriceCacheStore {
  PriceCacheStore(this._db);

  final AppDatabase _db;

  Future<List<PricePoint>> read(String symbol, String granularity) async {
    final rows =
        await (_db.select(_db.cachedPrices)
              ..where(
                (t) =>
                    t.symbol.equals(symbol) & t.granularity.equals(granularity),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.date)]))
            .get();
    return [for (final r in rows) PricePoint(r.date, r.close)];
  }

  Future<CacheMetaInfo?> meta(String symbol, String granularity) async {
    final row =
        await (_db.select(_db.cacheMeta)..where(
              (t) =>
                  t.symbol.equals(symbol) & t.granularity.equals(granularity),
            ))
            .getSingleOrNull();
    return row == null ? null : CacheMetaInfo(row.fetchedAt);
  }

  /// Inserts new points and overwrites existing dates (merge).
  Future<void> merge(
    String symbol,
    String granularity,
    List<PricePoint> points, {
    required DateTime fetchedAt,
  }) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.cachedPrices, [
        for (final p in points)
          CachedPricesCompanion.insert(
            symbol: symbol,
            granularity: granularity,
            date: p.date,
            close: p.close,
          ),
      ]);
      b.insert(
        _db.cacheMeta,
        CacheMetaCompanion.insert(
          symbol: symbol,
          granularity: granularity,
          fetchedAt: fetchedAt,
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> clear(String symbol, String granularity) async {
    await (_db.delete(_db.cachedPrices)..where(
          (t) => t.symbol.equals(symbol) & t.granularity.equals(granularity),
        ))
        .go();
    await (_db.delete(_db.cacheMeta)..where(
          (t) => t.symbol.equals(symbol) & t.granularity.equals(granularity),
        ))
        .go();
  }

  Future<void> clearAll() async {
    await _db.delete(_db.cachedPrices).go();
    await _db.delete(_db.cacheMeta).go();
  }

  /// Symbols that have at least [minPoints] weekly points cached.
  Future<List<String>> symbolsWithWeekly(int minPoints) async {
    final count = _db.cachedPrices.symbol.count();
    final query = _db.selectOnly(_db.cachedPrices)
      ..addColumns([_db.cachedPrices.symbol, count])
      ..where(_db.cachedPrices.granularity.equals('weekly'))
      ..groupBy([_db.cachedPrices.symbol]);
    final rows = await query.get();
    return [
      for (final r in rows)
        if ((r.read(count) ?? 0) >= minPoints) r.read(_db.cachedPrices.symbol)!,
    ];
  }
}
