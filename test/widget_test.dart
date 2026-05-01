import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MicroJournalApp boots to the home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MicroJournalApp());
    await tester.pumpAndSettle();

    expect(find.text('micro journal'), findsOneWidget);
  });

  testWidgets('Theme menu is accessible', (WidgetTester tester) async {
    await tester.pumpWidget(const MicroJournalApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('Autumn Warmth'), findsOneWidget);
    expect(find.text('Rainy Reflection'), findsOneWidget);
    expect(find.text('Winter Calm'), findsOneWidget);
    expect(find.text('Summer Vitality'), findsOneWidget);
  });
}
