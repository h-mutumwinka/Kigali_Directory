import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kigali_city_directory/main.dart';

void main() {
  testWidgets('Bottom navigation switches screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(KigaliDirectoryApp());

    expect(find.text('Kigali Directory'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();
    expect(find.text('My Listings'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.map));
    await tester.pumpAndSettle();
    expect(find.text('Map View'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });
}
