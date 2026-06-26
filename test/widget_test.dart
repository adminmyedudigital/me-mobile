import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:me_mobile/main.dart';
import 'package:me_mobile/screens/home/home_screen.dart';
import 'package:me_mobile/theme/theme.dart';

void main() {
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

    expect(find.text('ME Digital'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.assignment_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Upcoming exams'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.insert_chart_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Performance graph'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);
  });
}
