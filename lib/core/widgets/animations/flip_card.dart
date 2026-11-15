import 'dart:math';

import 'package:flutter/material.dart';

/// Card turning around its Y axis to reveal its back side.
/// AnimationController + AnimatedBuilder + Matrix4 rotation.
class FlipCard extends StatefulWidget {
  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.showBack,
  });

  final Widget front;
  final Widget back;
  final bool showBack;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
    value: widget.showBack ? 1 : 0,
  );

  @override
  void didUpdateWidget(FlipCard old) {
    super.didUpdateWidget(old);
    if (widget.showBack != old.showBack) {
      widget.showBack ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final angle = Curves.easeInOut.transform(_controller.value) * pi;
        final isBack = angle > pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: widget.back,
                )
              : widget.front,
        );
      },
    );
  }
}
