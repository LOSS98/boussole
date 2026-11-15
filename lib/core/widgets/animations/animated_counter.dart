import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Counts from 0 to [value] and colours the text green/red by sign.
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.format,
    this.style,
    this.duration = const Duration(milliseconds: 1400),
  });

  final double value;
  final String Function(double) format;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, v, _) => Text(
        format(v),
        style: (style ?? const TextStyle()).copyWith(
          color: v >= 0 ? AppColors.gain : AppColors.loss,
        ),
      ),
    );
  }
}
