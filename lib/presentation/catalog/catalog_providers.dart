import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/asset.dart';
import '../providers/market_providers.dart';
import '../providers/user_providers.dart';

class CatalogFilter {
  const CatalogFilter({this.query = '', this.type, this.favoritesOnly = false});

  final String query;
  final AssetType? type;
  final bool favoritesOnly;

  CatalogFilter copyWith({
    String? query,
    AssetType? Function()? type,
    bool? favoritesOnly,
  }) => CatalogFilter(
    query: query ?? this.query,
    type: type != null ? type() : this.type,
    favoritesOnly: favoritesOnly ?? this.favoritesOnly,
  );
}

class CatalogFilterNotifier extends Notifier<CatalogFilter> {
  @override
  CatalogFilter build() => const CatalogFilter();

  void setQuery(String q) => state = state.copyWith(query: q);
  void setType(AssetType? t) => state = state.copyWith(type: () => t);
  void toggleFavoritesOnly() =>
      state = state.copyWith(favoritesOnly: !state.favoritesOnly);
}

final catalogFilterProvider =
    NotifierProvider<CatalogFilterNotifier, CatalogFilter>(
      CatalogFilterNotifier.new,
    );

/// Catalog after search, type filter and favourites filter.
final filteredCatalogProvider = Provider<AsyncValue<List<Asset>>>((ref) {
  final filter = ref.watch(catalogFilterProvider);
  final favorites = ref.watch(favoritesProvider).value ?? const <String>{};
  return ref.watch(catalogProvider).whenData((assets) {
    final q = filter.query.trim().toLowerCase();
    return [
      for (final a in assets)
        if ((filter.type == null || a.type == filter.type) &&
            (!filter.favoritesOnly || favorites.contains(a.symbol)) &&
            (q.isEmpty ||
                a.name.toLowerCase().contains(q) ||
                a.symbol.toLowerCase().contains(q)))
          a,
    ];
  });
});
