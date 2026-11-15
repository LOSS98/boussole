import 'package:flutter/material.dart';

import '../config/app_info.dart';
import '../theme/app_spacing.dart';

/// School logo and the sentence explaining the academic context.
class SchoolBadge extends StatelessWidget {
  const SchoolBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Image.asset('assets/images/insa-logo.png', height: 44),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppInfo.schoolContext,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            height: 1.4,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
