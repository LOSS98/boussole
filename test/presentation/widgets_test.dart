import 'package:boussole/core/widgets/state_views.dart';
import 'package:boussole/core/widgets/stat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ErrorView shows the message and a working Retry button', (
    tester,
  ) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView(
            error: 'No internet connection.',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );
    expect(find.text('No internet connection.'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });

  testWidgets('StatTile displays label and value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatTile(label: 'Volatility', value: '24.0 %'),
        ),
      ),
    );
    expect(find.text('Volatility'), findsOneWidget);
    expect(find.text('24.0 %'), findsOneWidget);
  });
}
