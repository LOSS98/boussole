import 'package:equatable/equatable.dart';

enum AssetType {
  stock('Stock'),
  etf('ETF'),
  crypto('Crypto');

  const AssetType(this.label);
  final String label;

  static AssetType parse(String value) =>
      AssetType.values.firstWhere((t) => t.name == value);
}

/// An investable instrument of the catalog.
class Asset extends Equatable {
  const Asset({
    required this.symbol,
    required this.name,
    required this.type,
    required this.description,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
    symbol: json['symbol'] as String,
    name: json['name'] as String,
    type: AssetType.parse(json['type'] as String),
    description: json['description'] as String,
  );

  final String symbol;
  final String name;
  final AssetType type;
  final String description;

  /// Ticker used by Yahoo Finance (crypto pairs are quoted against USD).
  String get yahooSymbol => type == AssetType.crypto ? '$symbol-USD' : symbol;

  @override
  List<Object?> get props => [symbol];
}
