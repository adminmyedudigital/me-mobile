import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:me_mobile/main.dart';

void main() {
  Future<void> signIn(WidgetTester tester) async {
    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'student');
    await tester.enterText(fields.at(1), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pumpAndSettle();
  }

  testWidgets('renders auth tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Username'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('auth-tab-sign-up')));
    await tester.pumpAndSettle();

    expect(find.text('Sign Up'), findsWidgets);
    expect(find.text('Confirm Password'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('auth-tab-sign-in')));
    await tester.pumpAndSettle();

    expect(find.text('Username'), findsWidgets);
  });

  testWidgets('renders dashboard bottom tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await signIn(tester);

    expect(find.text('Dashboard'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.assignment_outlined));
    await tester.pumpAndSettle();
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Jul 4, 2026'), findsOneWidget);
    expect(find.text('86 / 100'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.insert_chart_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Progress'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);
  });
}
