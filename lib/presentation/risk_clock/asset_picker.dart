import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/asset_avatar.dart';
import '../../core/widgets/state_views.dart';
import '../../domain/models/asset.dart';
import '../providers/market_providers.dart';

/// Bottom sheet listing the catalog; returns the chosen asset.
Future<Asset?> pickAsset(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<Asset>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _AssetPickerSheet(),
  );
}

class _AssetPickerSheet extends ConsumerWidget {
  const _AssetPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: AsyncValueView<List<Asset>>(
        value: catalog,
        onRetry: () => ref.invalidate(catalogProvider),
        data: (assets) => ListView.builder(
          itemCount: assets.length,
          itemBuilder: (_, i) {
            final a = assets[i];
            return ListTile(
              leading: AssetAvatar(a, size: 40),
              title: Text(
                a.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text('${a.symbol} · ${a.type.label}'),
              onTap: () => Navigator.of(context).pop(a),
            );
          },
        ),
      ),
    );
  }
}
