import 'package:intl/intl.dart';

abstract final class Fmt {
  static final _date = DateFormat('d MMM yyyy');
  static final _dateTime = DateFormat("d MMM yyyy 'at' HH:mm");

  static String date(DateTime d) => _date.format(d);
  static String dateTime(DateTime d) => _dateTime.format(d);

  /// "+12.3 %" / "-4.0 %".
  static String percent(double? v, {int digits = 1, bool sign = true}) {
    if (v == null) return '—';
    final s = v.toStringAsFixed(digits);
    return '${sign && v > 0 ? '+' : ''}$s %';
  }

  static String money(double v, {String symbol = '\$', int digits = 2}) {
    final f = NumberFormat.currency(symbol: symbol, decimalDigits: digits);
    return f.format(v);
  }

  /// Compact price: more decimals for tiny values (e.g. DOGE).
  static String price(double v, {String symbol = '\$'}) =>
      money(v, symbol: symbol, digits: v.abs() < 1 ? 4 : 2);
}
