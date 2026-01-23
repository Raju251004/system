// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system/main.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;

    const MethodChannel channel = MethodChannel(
      'plugin.csdcorp.com/speech_to_text',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return null; // Mock return value
        });
  });

  testWidgets('Status Page loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // SystemApp wrapper in ProviderScope
    await tester.pumpWidget(const ProviderScope(child: SystemApp()));

    // Verify that the Status Window title exists.
    expect(find.text('STATUS'), findsOneWidget);

    // Verify that the user name exists.
    expect(find.text('Sung Jin-Woo'), findsOneWidget);
  });
}
