import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// One-shot confetti burst, drawn with a [CustomPainter].
class Confetti extends StatefulWidget {
  const Confetti({super.key});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..forward();
  final _random = Random();
  late final List<_Piece> _pieces = List.generate(
    40,
    (_) => _Piece(
      angle: -pi / 2 + (_random.nextDouble() - 0.5) * pi * 0.9,
      speed: 180 + _random.nextDouble() * 260,
      size: 5 + _random.nextDouble() * 6,
      spin: _random.nextDouble() * 6,
      color: const [
        AppColors.blue,
        AppColors.green,
        AppColors.teal,
        AppColors.warning,
        AppColors.loss,
      ][_random.nextInt(5)],
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) =>
            CustomPaint(painter: _ConfettiPainter(_pieces, _controller.value)),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _Piece {
  _Piece({
    required this.angle,
    required this.speed,
    required this.size,
    required this.spin,
    required this.color,
  });
  final double angle, speed, size, spin;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.t);
  final List<_Piece> pieces;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height * 0.45);
    for (final p in pieces) {
      final dx = cos(p.angle) * p.speed * t;
      final dy = sin(p.angle) * p.speed * t + 420 * t * t;
      canvas.save();
      canvas.translate(origin.dx + dx, origin.dy + dy);
      canvas.rotate(p.spin * t * 6);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.6,
        ),
        Paint()..color = p.color.withValues(alpha: 1 - t),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
