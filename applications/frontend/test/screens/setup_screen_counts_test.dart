
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/setup_screen.dart';
import 'package:frontend/state/game_state.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/game_constants.dart';

void main() {
  testWidgets('SetupScreen displays card counts in headers', (WidgetTester tester) async {
    // Build the SetupScreen wrapped in a provider
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<GameState>(
          create: (_) => GameState(),
          child: const SetupScreen(),
        ),
      ),
    );

    // Initial state: "Suspects (0)" should exist because count logic is implemented
    expect(find.text('Suspects (0)'), findsOneWidget);

    // Tap a card
    final suspectChip = find.widgetWithText(FilterChip, 'Colonel Mustard');
    await tester.ensureVisible(suspectChip);
    await tester.tap(suspectChip);
    await tester.pump();

    // Verify the header updates to show count
    expect(find.text('Suspects (1)'), findsOneWidget);
  });
}
