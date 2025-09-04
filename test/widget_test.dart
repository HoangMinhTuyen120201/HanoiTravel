// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/screens/splash_screen.dart';
import 'package:travel_app/utils/locale_text.dart';

void main() {
  testWidgets('SplashScreen shows welcome text and progress indicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen(lang: 'en')));

    expect(find.text(appTexts['en']!['welcome']!), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
