import 'package:boussole/core/glossary/glossary_entries.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('glossary ids are unique and every entry is filled', () {
    final ids = Glossary.entries.map((e) => e.id).toList();
    expect(ids.toSet().length, ids.length);
    for (final e in Glossary.entries) {
      expect(e.term, isNotEmpty);
      expect(e.definition.length, greaterThan(20));
      expect(e.inBoussole, isNotEmpty);
    }
  });

  test('every Panic button action has an explanation', () {
    for (final id in [
      'hold',
      'stay-in-cash',
      'sell-all',
      'buy-more',
      'buy-back',
    ]) {
      expect(Glossary.byId(id), isNotNull, reason: id);
    }
    expect(Glossary.byId('nope'), isNull);
  });
}
