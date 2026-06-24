import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:me_mobile/main.dart';

void main() {
  testWidgets('renders auth tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Email Id'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('auth-tab-sign-up')));
    await tester.pumpAndSettle();

    expect(find.text('Signup'), findsWidgets);
    expect(find.text('Confirm Password'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('auth-tab-sign-in')));
    await tester.pumpAndSettle();

    expect(find.text('Email Id'), findsOneWidget);
  });
}
