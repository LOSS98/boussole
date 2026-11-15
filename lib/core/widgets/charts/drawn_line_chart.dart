import 'package:flutter/material.dart';

/// One curve of a [DrawnLineChart].
class ChartSeries {
  const ChartSeries(this.values, this.color, {this.width = 3});
  final List<double> values;
  final Color color;
  final double width;
}

/// Line chart whose curves are progressively drawn from left to right.
/// A [CustomPainter] driven by a 0 -> 1 tween (AnimationController).
class DrawnLineChart extends StatefulWidget {
  const DrawnLineChart({
    super.key,
    required this.series,
    this.height = 220,
    this.duration = const Duration(milliseconds: 2200),
  });

  final List<ChartSeries> series;
  final double height;
  final Duration duration;

  @override
  State<DrawnLineChart> createState() => _DrawnLineChartState();
}

class _DrawnLineChartState extends State<DrawnLineChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..forward();
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutCubic,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _progress,
            builder: (_, _) => CustomPaint(
              painter: _DrawnLinePainter(
                widget.series,
                _progress.value,
                Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _controller.forward(from: 0),
            icon: const Icon(Icons.replay_rounded, size: 18),
            label: const Text('Replay'),
          ),
        ),
      ],
    );
  }
}

class _DrawnLinePainter extends CustomPainter {
  _DrawnLinePainter(this.series, this.progress, this.gridColor);

  final List<ChartSeries> series;
  final double progress;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final all = [for (final s in series) ...s.values];
    if (all.isEmpty) return;
    final minV = all.reduce((a, b) => a < b ? a : b);
    final maxV = all.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV) == 0 ? 1 : (maxV - minV);
    const pad = 8.0;
    final h = size.height - pad * 2;

    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = pad + h * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    for (final s in series) {
      if (s.values.length < 2) continue;
      final path = Path();
      for (var i = 0; i < s.values.length; i++) {
        final x = size.width * i / (s.values.length - 1);
        final y = pad + h * (1 - (s.values[i] - minV) / range);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      final metric = path.computeMetrics().first;
      final visible = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(
        visible,
        Paint()
          ..color = s.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = s.width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      final tip = metric.getTangentForOffset(metric.length * progress);
      if (tip != null) {
        canvas.drawCircle(tip.position, 5, Paint()..color = s.color);
      }
    }
  }

  @override
  bool shouldRepaint(_DrawnLinePainter old) =>
      old.progress != progress || old.series != series;
}
