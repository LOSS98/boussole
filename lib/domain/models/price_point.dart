import 'package:equatable/equatable.dart';

/// A closing price at a given date.
class PricePoint extends Equatable {
  const PricePoint(this.date, this.close);

  final DateTime date;
  final double close;

  @override
  List<Object?> get props => [date, close];
}
