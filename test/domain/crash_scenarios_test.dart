import 'dart:convert';
import 'dart:io';

import 'package:boussole/domain/calculations/drawdown.dart';
import 'package:boussole/domain/models/crash_scenario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final s in crashScenarios) {
    test('${s.title}: bundled data is valid and contains a real crash', () {
      final raw =
          jsonDecode(File('assets/data/${s.file}').readAsStringSync()) as List;
      expect(raw.length, greaterThan(20));
      final closes = [for (final r in raw) (r[1] as num).toDouble()];
      expect(closes.every((c) => c > 0), isTrue);
      expect(maxDrawdown(closes)!.depth, lessThan(-0.15));
    });
  }
}
