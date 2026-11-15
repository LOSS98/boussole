import 'package:flutter/material.dart';

import '../../domain/models/risk_level.dart';
import '../theme/app_colors.dart';

extension RiskLevelColor on RiskLevel {
  Color get color => switch (this) {
    RiskLevel.low => AppColors.gain,
    RiskLevel.moderate => AppColors.blue,
    RiskLevel.high => AppColors.warning,
    RiskLevel.veryHigh => AppColors.loss,
  };
}

class RiskBadge extends StatelessWidget {
  const RiskBadge(this.level, {super.key, this.period});

  final RiskLevel level;

  /// Period the level was measured on (e.g. "1Y"), shown when given.
  final String? period;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        period == null ? level.label : '${level.label} · $period',
        style: TextStyle(
          color: level.color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
