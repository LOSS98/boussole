import 'package:equatable/equatable.dart';

import 'price_point.dart';

/// Time resolution of a stored price series.
enum Granularity {
  daily(Duration(hours: 24)),
  weekly(Duration(days: 7));

  const Granularity(this.maxAge);

  /// How long cached data is considered fresh.
  final Duration maxAge;
}

/// Where the data currently shown comes from.
enum HistoryStatus {
  /// Cache is recent or was just downloaded.
  fresh,

  /// Cached data is displayed while a refresh is running.
  refreshing,

  /// The refresh failed: cached data may be outdated.
  stale,
}

class PriceHistory extends Equatable {
  const PriceHistory({
    required this.symbol,
    required this.granularity,
    required this.points,
    this.lastUpdated,
    this.status = HistoryStatus.fresh,
    this.errorMessage,
  });

  final String symbol;
  final Granularity granularity;

  /// Sorted by date, oldest first.
  final List<PricePoint> points;
  final DateTime? lastUpdated;
  final HistoryStatus status;

  final String? errorMessage;

  bool get isEmpty => points.isEmpty;
  List<double> get closes => [for (final p in points) p.close];

  PriceHistory copyWith({
    List<PricePoint>? points,
    DateTime? lastUpdated,
    HistoryStatus? status,
    String? errorMessage,
  }) => PriceHistory(
    symbol: symbol,
    granularity: granularity,
    points: points ?? this.points,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    symbol,
    granularity,
    points,
    lastUpdated,
    status,
    errorMessage,
  ];
}
