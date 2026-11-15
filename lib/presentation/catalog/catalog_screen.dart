import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/glossary_button.dart';
import '../../core/widgets/state_views.dart';
import '../../domain/models/asset.dart';
import '../providers/market_providers.dart';
import '../providers/user_providers.dart';
import 'asset_tile.dart';
import 'catalog_providers.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(catalogFilterProvider);
    final notifier = ref.read(catalogFilterProvider.notifier);
    final assets = ref.watch(filteredCatalogProvider);
    final favorites = ref.watch(favoritesProvider).value ?? const <String>{};

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 34),
            const SizedBox(width: AppSpacing.sm + 2),
            const Text('Boussole'),
          ],
        ),
        actions: [
          const GlossaryButton(),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              onChanged: notifier.setQuery,
              decoration: const InputDecoration(
                hintText: 'Search a name or symbol',
                prefixIcon: Icon(Icons.search_rounded),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _Chip(
                  label: 'All',
                  selected: filter.type == null && !filter.favoritesOnly,
                  onTap: () {
                    notifier.setType(null);
                    if (filter.favoritesOnly) notifier.toggleFavoritesOnly();
                  },
                ),
                for (final t in AssetType.values)
                  _Chip(
                    label: t.label,
                    selected: filter.type == t,
                    onTap: () => notifier.setType(filter.type == t ? null : t),
                  ),
                _Chip(
                  label: 'Favorites',
                  icon: Icons.favorite_rounded,
                  selected: filter.favoritesOnly,
                  onTap: notifier.toggleFavoritesOnly,
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncValueView<List<Asset>>(
              value: assets,
              onRetry: () => ref.invalidate(catalogProvider),
              data: (list) {
                if (list.isEmpty) {
                  return EmptyView(
                    icon: filter.favoritesOnly
                        ? Icons.favorite_border_rounded
                        : Icons.search_off_rounded,
                    title: filter.favoritesOnly && favorites.isEmpty
                        ? 'No favorites yet'
                        : 'No result',
                    message: filter.favoritesOnly && favorites.isEmpty
                        ? 'Tap the heart on an asset to follow it here.'
                        : 'Try another search or filter.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: list.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm + 2),
                  itemBuilder: (_, i) => AssetTile(
                    asset: list[i],
                    isFavorite: favorites.contains(list[i].symbol),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        avatar: icon == null ? null : Icon(icon, size: 16),
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
