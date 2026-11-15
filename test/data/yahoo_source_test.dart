import 'package:boussole/data/remote/price_source.dart';
import 'package:boussole/data/remote/yahoo_finance_source.dart';
import 'package:boussole/domain/models/asset.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> payload(List<int> ts, List<dynamic> closes) => {
  'chart': {
    'result': [
      {
        'timestamp': ts,
        'indicators': {
          'quote': [
            {'close': closes},
          ],
        },
      },
    ],
    'error': null,
  },
};

void main() {
  test('parses closes into sorted points and skips nulls', () {
    final points = YahooFinanceSource.parse(
      payload(
        [1704205800, 1704119400, 1704292200], // 2 Jan, 1 Jan... unsorted
        [11.5, 10, null],
      ),
    );
    expect(points.length, 2);
    expect(points.first.close, 10);
    expect(points.last.close, 11.5);
    expect(points.first.date.isBefore(points.last.date), isTrue);
  });

  test('keeps one point per date', () {
    final points = YahooFinanceSource.parse(
      payload([1704119400, 1704123000], [10.0, 12.0]),
    );
    expect(points.single.close, 12.0);
  });

  test('a Yahoo error becomes an ApiException', () {
    expect(
      () => YahooFinanceSource.parse({
        'chart': {
          'result': null,
          'error': {'code': 'Not Found', 'description': 'No data found'},
        },
      }),
      throwsA(isA<ApiException>()),
    );
  });

  test('empty result is an error', () {
    expect(
      () => YahooFinanceSource.parse({
        'chart': {'result': []},
      }),
      throwsA(isA<ApiException>()),
    );
  });

  test('crypto symbols are quoted against USD', () {
    const btc = Asset(
      symbol: 'BTC',
      name: 'Bitcoin',
      type: AssetType.crypto,
      description: '',
    );
    const aapl = Asset(
      symbol: 'AAPL',
      name: 'Apple',
      type: AssetType.stock,
      description: '',
    );
    expect(btc.yahooSymbol, 'BTC-USD');
    expect(aapl.yahooSymbol, 'AAPL');
  });
}
