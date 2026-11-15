import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/legal/legal_documents.dart';
import '../../data/local/database.dart';
import '../../data/local/price_cache_store.dart';
import '../../data/local/user_store.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/market_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/remote/yahoo_finance_source.dart';

/// Dependency wiring: database, HTTP client and repositories.

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final userStoreProvider = Provider(
  (ref) => UserStore(ref.watch(databaseProvider)),
);

final priceCacheStoreProvider = Provider(
  (ref) => PriceCacheStore(ref.watch(databaseProvider)),
);

final catalogRepositoryProvider = Provider((ref) => CatalogRepository());

final userRepositoryProvider = Provider(
  (ref) => UserRepository(ref.watch(userStoreProvider)),
);

final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(ref.watch(userStoreProvider)),
);

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  final yahoo = YahooFinanceSource(ref.watch(httpClientProvider));
  return MarketRepository(
    store: ref.watch(priceCacheStoreProvider),
    source: yahoo,
    rates: yahoo,
  );
});

// ---- Settings ---------------------------------------------------------------

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() => ref.read(settingsRepositoryProvider).load();

  Future<void> apply(AppSettings Function(AppSettings) change) async {
    final next = change(state.requireValue);
    state = AsyncData(next);
    await ref.read(settingsRepositoryProvider).save(next);
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

// ---- Legal acceptance --------------------------------------------------------

class LegalNotifier extends AsyncNotifier<LegalAcceptance> {
  @override
  Future<LegalAcceptance> build() =>
      ref.read(settingsRepositoryProvider).loadLegal();

  Future<void> accept() async {
    state = AsyncData(
      await ref
          .read(settingsRepositoryProvider)
          .acceptLegal(LegalDocuments.version),
    );
  }

  /// Deletes all user data and the acceptance: the welcome screen shows again.
  Future<void> deleteEverything() async {
    await ref.read(settingsRepositoryProvider).deleteAllUserData();
    await ref.read(marketRepositoryProvider).clearCache();
    ref.invalidate(settingsProvider);
    state = const AsyncData(LegalAcceptance());
  }
}

final legalProvider = AsyncNotifierProvider<LegalNotifier, LegalAcceptance>(
  LegalNotifier.new,
);

extension LegalAcceptanceX on LegalAcceptance {
  bool get isCurrent => version == LegalDocuments.version;
}
