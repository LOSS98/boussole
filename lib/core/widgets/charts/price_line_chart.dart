import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/price_point.dart';
import '../../theme/app_colors.dart';
import '../../utils/formatters.dart';

/// Interactive price curve (fl_chart). Green if the period ended higher.
class PriceLineChart extends StatelessWidget {
  const PriceLineChart({
    super.key,
    required this.points,
    this.currencySymbol = '\$',
    this.height = 220,
  });

  final List<PricePoint> points;
  final String currencySymbol;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('Not enough data for this period.')),
      );
    }
    final up = points.last.close >= points.first.close;
    final color = up ? AppColors.gain : AppColors.loss;
    final values = [for (final p in points) p.close];
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY) * 0.1;

    return SizedBox(
      height: height,
      child: LineChart(
        duration: const Duration(milliseconds: 300),
        LineChartData(
          minY: minY - pad,
          maxY: maxY + pad,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    '${Fmt.date(points[s.spotIndex].date)}\n'
                    '${Fmt.price(s.y, symbol: currencySymbol)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i].close),
              ],
              isCurved: false,
              color: color,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.25),
                    color.withValues(alpha: 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
