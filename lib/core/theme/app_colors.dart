import 'package:flutter/material.dart';

/// Brand palette taken from the Boussole logo.
abstract final class AppColors {
  static const navy = Color(0xFF0F1F44);
  static const blue = Color(0xFF0A6CFF);
  static const teal = Color(0xFF0E9AA7);
  static const green = Color(0xFF2DB36B);
  static const gain = Color(0xFF1FA463);
  static const loss = Color(0xFFE5484D);
  static const warning = Color(0xFFF5A524);

  static const lightBackground = Color(0xFFF5F7FC);
  static const darkBackground = Color(0xFF0A1224);
  static const darkSurface = Color(0xFF121D36);

  static const brandGradient = LinearGradient(
    colors: [blue, teal, green],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
