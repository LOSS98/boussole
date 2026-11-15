import 'package:flutter/material.dart';

import '../../domain/models/asset.dart';
import '../theme/app_colors.dart';

/// Round badge with the asset symbol. Shared by the catalog and the detail
/// screen through a [Hero].
class AssetAvatar extends StatelessWidget {
  const AssetAvatar(this.asset, {super.key, this.size = 46, this.hero = false});

  final Asset asset;
  final double size;

  /// Enable only where a catalog -> detail transition exists.
  final bool hero;

  Color get _color => switch (asset.type) {
    AssetType.stock => AppColors.blue,
    AssetType.etf => AppColors.teal,
    AssetType.crypto => AppColors.warning,
  };

  @override
  Widget build(BuildContext context) {
    final label = asset.symbol.length > 4
        ? asset.symbol.substring(0, 4)
        : asset.symbol;
    final badge = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color.withValues(alpha: 0.14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _color,
          fontWeight: FontWeight.w800,
          fontSize: size * (label.length > 3 ? 0.24 : 0.28),
        ),
      ),
    );
    return hero ? Hero(tag: 'asset-${asset.symbol}', child: badge) : badge;
  }
}
