import 'package:flutter/material.dart';

import '../../domain/models/price_history.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/formatters.dart';

/// Tells the user when data is old, being refreshed or synthetic.
class DataStatusBanner extends StatelessWidget {
  const DataStatusBanner(this.history, {super.key});

  final PriceHistory history;

  @override
  Widget build(BuildContext context) {
    final updated = history.lastUpdated;
    final String? text;
    final IconData icon;
    final Color color;
    if (history.status == HistoryStatus.stale) {
      text = updated == null
          ? 'Offline: showing saved data.'
          : 'Offline: data from ${Fmt.dateTime(updated)}.';
      icon = Icons.cloud_off_rounded;
      color = AppColors.warning;
    } else if (history.status == HistoryStatus.refreshing) {
      text = 'Refreshing data…';
      icon = Icons.sync_rounded;
      color = AppColors.blue;
    } else {
      text = null;
      icon = Icons.check;
      color = AppColors.gain;
    }
    if (text == null) return const SizedBox.shrink();
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
