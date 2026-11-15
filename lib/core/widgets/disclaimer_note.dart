import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Reminder shown next to every indicator: it describes the past only.
class DisclaimerNote extends StatelessWidget {
  const DisclaimerNote({
    super.key,
    this.text =
        'This describes the past. It is not a prediction of the future.',
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 12, color: color)),
          ),
        ],
      ),
    );
  }
}
