import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/calculations/loss_probability.dart';
import 'risk_clock_controller.dart';

/// Histogram of loss probabilities. Bars animate when values change.
class LossBars extends StatelessWidget {
  const LossBars({
    super.key,
    required this.bars,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<LossProbability?> bars;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _height = 150.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: _height + 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < bars.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelect(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      bars[i] == null
                          ? 'n/a'
                          : '${(bars[i]!.probability * 100).round()}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: bars[i]?.probability ?? 0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, _) => Container(
                        width: 22,
                        height: (v * _height).clamp(4, _height),
                        decoration: BoxDecoration(
                          color: bars[i] == null
                              ? theme.dividerColor
                              : (i == selectedIndex
                                    ? AppColors.loss
                                    : AppColors.loss.withValues(alpha: 0.35)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      periodLabel(holdingPeriods[i]),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: i == selectedIndex
                            ? FontWeight.w900
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
