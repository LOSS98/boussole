import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/animations/favorite_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/asset_avatar.dart';
import '../../domain/models/asset.dart';
import '../providers/infra_providers.dart';

class AssetTile extends ConsumerWidget {
  const AssetTile({super.key, required this.asset, required this.isFavorite});

  final Asset asset;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      onTap: () => context.push(Routes.asset(asset.symbol)),
      child: Row(
        children: [
          AssetAvatar(asset, hero: true),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${asset.symbol} · ${asset.type.label}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          FavoriteButton(
            isFavorite: isFavorite,
            onChanged: (v) =>
                ref.read(userRepositoryProvider).setFavorite(asset.symbol, v),
          ),
        ],
      ),
    );
  }
}
