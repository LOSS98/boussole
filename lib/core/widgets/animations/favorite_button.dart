import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Heart that bounces when toggled on.
class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onChanged,
  });

  final bool isFavorite;
  final ValueChanged<bool> onChanged;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 1.45, end: 1.0), weight: 60),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: widget.isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: () {
        final next = !widget.isFavorite;
        if (next) _controller.forward(from: 0);
        widget.onChanged(next);
      },
      icon: ScaleTransition(
        scale: _scale,
        child: Icon(
          widget.isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: widget.isFavorite ? AppColors.loss : null,
        ),
      ),
    );
  }
}
