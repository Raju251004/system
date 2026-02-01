import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:system/main.dart';

void main() {
  testWidgets('Login screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: SoloLevelingApp()));

    // Verify that Login Screen text appears
    expect(find.text('SYSTEM ACCESS'), findsOneWidget);
    expect(find.text('LOG IN'), findsOneWidget);
  });
}
