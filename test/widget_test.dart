// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:auto_picker/components/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/flutter_driver.dart' as d;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:auto_picker/main.dart';

void main() {
  enableFlutterDriverExtension();

  group('Home Screen Test', () {
    d.FlutterDriver driver;
    setUpAll(() async {
      // Connects to the app
      driver = await d.FlutterDriver.connect();
    });
    tearDownAll(() async {
      if (driver != null) {
        // Closes the connection
        driver.close();
      }
    });
    testWidgets('Home Page has a title and message', (tester) async {
      await tester.pumpWidget(const HomePage());
      final titleFinder = find.text('Mechanics');
      final messageFinder = find.text('M');

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that the Text widgets appear exactly once in the widget tree.
      expect(titleFinder, findsOneWidget);
      expect(messageFinder, findsOneWidget);
    });
  });
}
