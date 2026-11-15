import 'package:http/http.dart' as http;

import '../../domain/models/asset.dart';
import '../../domain/models/price_history.dart';
import '../../domain/models/price_point.dart';
import 'http_helpers.dart';
import 'price_source.dart';

/// Single data provider of the app: Yahoo Finance chart endpoint.
/// No API key. It serves stocks, ETFs, crypto pairs and the EUR/USD rate.
/// This endpoint is not an official, documented API and may change.
class YahooFinanceSource implements PriceSource, RatesSource {
  YahooFinanceSource(this._client);

  final http.Client _client;

  static const _headers = {
    'User-Agent': 'Mozilla/5.0 (Boussole educational app)',
  };

  @override
  Future<List<PricePoint>> fetch(
    Asset asset,
    Granularity granularity, {
    DateTime? since,
  }) {
    final weekly = granularity == Granularity.weekly;
    return _chart(
      asset.yahooSymbol,
      interval: weekly ? '1wk' : '1d',
      range: weekly ? '10y' : '1y',
      since: since,
    );
  }

  /// EUR per 1 USD, derived from the EURUSD=X quote (USD per 1 EUR).
  @override
  Future<List<PricePoint>> fetchUsdToEur({DateTime? since}) async {
    final usdPerEur = await _chart(
      'EURUSD=X',
      interval: '1d',
      range: '10y',
      since: since,
    );
    return [
      for (final p in usdPerEur)
        if (p.close > 0) PricePoint(p.date, 1 / p.close),
    ];
  }

  Future<List<PricePoint>> _chart(
    String symbol, {
    required String interval,
    required String range,
    DateTime? since,
  }) async {
    final query = <String, String>{'interval': interval};
    if (since == null) {
      query['range'] = range;
    } else {
      // Only the missing part (one extra week to refresh the last point).
      final from = since.subtract(const Duration(days: 7));
      query['period1'] = '${from.millisecondsSinceEpoch ~/ 1000}';
      query['period2'] =
          '${DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch ~/ 1000}';
    }
    final uri = Uri.https(
      'query1.finance.yahoo.com',
      '/v8/finance/chart/$symbol',
      query,
    );
    return parse(await getJson(_client, uri, headers: _headers));
  }

  /// Converts a Yahoo chart payload into sorted points (one per date).
  static List<PricePoint> parse(Map<String, dynamic> json) {
    final chart = json['chart'];
    if (chart is! Map<String, dynamic>) {
      throw const ApiException('Unexpected response format.');
    }
    final error = chart['error'];
    if (error is Map && error['description'] != null) {
      throw ApiException('Yahoo Finance: ${error['description']}');
    }
    final results = chart['result'];
    if (results is! List || results.isEmpty) {
      throw const ApiException('No data returned for this symbol.');
    }
    final result = results.first as Map<String, dynamic>;
    final timestamps = (result['timestamp'] as List?) ?? const [];
    final quotes = (result['indicators']?['quote'] as List?) ?? const [];
    final closes = quotes.isEmpty
        ? const []
        : (quotes.first['close'] as List? ?? const []);

    final byDate = <DateTime, double>{};
    for (var i = 0; i < timestamps.length && i < closes.length; i++) {
      final close = closes[i];
      if (close == null) continue;
      final t = DateTime.fromMillisecondsSinceEpoch(
        (timestamps[i] as int) * 1000,
        isUtc: true,
      );
      byDate[DateTime(t.year, t.month, t.day)] = (close as num).toDouble();
    }
    return [for (final e in byDate.entries) PricePoint(e.key, e.value)]
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
