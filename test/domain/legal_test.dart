import 'package:boussole/core/legal/legal_documents.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all legal documents exist and are not empty', () {
    expect(LegalDocuments.all.map((d) => d.id), [
      'terms',
      'disclaimer',
      'privacy',
      'notice',
    ]);
    for (final d in LegalDocuments.all) {
      expect(d.sections, isNotEmpty);
      expect(LegalDocuments.byId(d.id), same(d));
    }
    expect(LegalDocuments.byId('nope'), isNull);
  });
}
