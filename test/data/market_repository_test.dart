import 'package:boussole/data/local/database.dart';
import 'package:boussole/data/local/price_cache_store.dart';
import 'package:boussole/data/remote/price_source.dart';
import 'package:boussole/data/repositories/market_repository.dart';
import 'package:boussole/domain/models/asset.dart';
import 'package:boussole/domain/models/price_history.dart';
import 'package:boussole/domain/models/price_point.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSource implements PriceSource {
  int calls = 0;
  bool failing = false;
  DateTime? lastSince;
  List<PricePoint> data = [
    PricePoint(DateTime(2024, 1, 1), 10),
    PricePoint(DateTime(2024, 1, 2), 11),
  ];

  @override
  Future<List<PricePoint>> fetch(
    Asset asset,
    Granularity granularity, {
    DateTime? since,
  }) async {
    calls++;
    lastSince = since;
    if (failing) throw const ApiException('No internet connection.');
    return data;
  }
}

class FakeRates implements RatesSource {
  @override
  Future<List<PricePoint>> fetchUsdToEur({DateTime? since}) async => [];
}

void main() {
  const asset = Asset(
    symbol: 'AAA',
    name: 'Aaa',
    type: AssetType.stock,
    description: '',
  );
  late AppDatabase db;
  late FakeSource source;
  late DateTime now;
  late MarketRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    source = FakeSource();
    now = DateTime(2024, 6, 1, 12);
    repo = MarketRepository(
      store: PriceCacheStore(db),
      source: source,
      rates: FakeRates(),
      now: () => now,
    );
  });

  tearDown(() => db.close());

  Future<List<PriceHistory>> load([Granularity g = Granularity.daily]) =>
      repo.watchHistory(asset, g).toList();

  test('first load downloads and stores the data', () async {
    final out = await load();
    expect(source.calls, 1);
    expect(out.single.status, HistoryStatus.fresh);
    expect(out.single.points.length, 2);
  });

  test('does not call the network when the cache is recent', () async {
    await load();
    now = now.add(const Duration(hours: 23));
    final out = await load();
    expect(source.calls, 1);
    expect(out.single.status, HistoryStatus.fresh);
    expect(out.single.lastUpdated, isNotNull);
  });

  test('weekly cache stays valid for several days', () async {
    await load(Granularity.weekly);
    now = now.add(const Duration(days: 6));
    await load(Granularity.weekly);
    expect(source.calls, 1);
    now = now.add(const Duration(days: 2));
    await load(Granularity.weekly);
    expect(source.calls, 2);
  });

  test('old cache is shown first, refreshed, and merged', () async {
    await load();
    now = now.add(const Duration(hours: 25));
    source.data = [
      PricePoint(DateTime(2024, 1, 2), 11),
      PricePoint(DateTime(2024, 1, 3), 12),
    ];
    final out = await load();
    expect(out.map((h) => h.status), [
      HistoryStatus.refreshing,
      HistoryStatus.fresh,
    ]);
    expect(source.lastSince, DateTime(2024, 1, 2));
    expect(out.last.points.length, 3);
  });

  test('offline with cache: emits stale data with the error', () async {
    await load();
    now = now.add(const Duration(days: 2));
    source.failing = true;
    final out = await load();
    expect(out.last.status, HistoryStatus.stale);
    expect(out.last.points, isNotEmpty);
    expect(out.last.errorMessage, 'No internet connection.');
  });

  test('offline without cache: the error is propagated', () async {
    source.failing = true;
    expect(load(), throwsA(isA<ApiException>()));
  });

  test('empty response without cache is an error', () async {
    source.data = [];
    expect(load(), throwsA(isA<ApiException>()));
  });

  test('force refresh bypasses a fresh cache', () async {
    await load();
    await repo.watchHistory(asset, Granularity.daily, force: true).toList();
    expect(source.calls, 2);
  });
}
