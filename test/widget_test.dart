import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quit_smoking/main.dart'; // Correct the import path based on your app name

void main() {
  testWidgets('Home Screen displays title and buttons',
      (WidgetTester tester) async {
    // Build the QuitSmokingApp widget.
    await tester.pumpWidget(QuitSmokingApp());

    // Verify if the home screen title exists.
    expect(find.text('Quit Smoking App'), findsOneWidget);

    // Verify if the ElevatedButton exists.
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Tap the ElevatedButton and trigger a frame.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Add further checks here if needed to verify changes after tapping the button.
  });
}
