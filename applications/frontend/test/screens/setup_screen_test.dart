import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/screens/setup_screen.dart';
import 'package:frontend/state/game_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('SetupScreen initializes and starts game', (WidgetTester tester) async {
    final gameState = GameState();

    // Set surface size to ensure widgets are visible
    await tester.binding.setSurfaceSize(const Size(800, 1200));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: gameState,
        child: const MaterialApp(
          home: SetupScreen(),
        ),
      ),
    );

    // Verify initial player inputs exist (My Name + Player 2 + Player 3)
    expect(find.widgetWithText(TextFormField, 'My Name (User)'), findsOneWidget);
    // Note: 'Player 2' and 'Player 3' are both labels and initial values, so strict finding might be tricky.
    // We check that we have 3 initial TextFormFields.
    expect(find.byType(TextFormField), findsNWidgets(3));

    // Test entering a name for the second player (index 1)
    final textFormFields = find.byType(TextFormField);
    await tester.enterText(textFormFields.at(1), 'Bob');

    // Test adding a player
    final addBtn = find.byIcon(Icons.add_circle);

    // Ensure visible and tap
    // Note: scrollUntilVisible might fail if multiple scrollables are found.
    // Given we set surface size to 800x1200, it's likely visible.
    // If not, we can use Drag.
    // Let's try to just tap it first.
    await tester.tap(addBtn);
    await tester.pumpAndSettle();

    // Verify we have 4 inputs now
    expect(find.byType(TextFormField), findsNWidgets(4));

    // Also verify the text "Player 4" exists somewhere.
    // We already verified we have 4 TextFormFields.
    // To check the name 'Player 4', we can check the text exists.
    // As seen in previous errors, find.widgetWithText might find duplicates due to label+content matching.
    // So we just check that 'Player 4' text is present.

    expect(find.text('Player 4'), findsAtLeastNWidgets(1));

    // Test selecting a card (e.g., first suspect)
    final suspectCard = GameConstants.suspects.first.name;

    // Drag up to see cards
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Tap card
    await tester.tap(find.text(suspectCard));
    await tester.pump();

    // Verify start game
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Game'));
    await tester.pump();

    expect(gameState.gameStarted, isTrue);
    expect(gameState.players.length, 4); // User, Bob, Player 3, Player 4
    expect(gameState.players[1].name, 'Bob');
    // Verify card selection logic from GameState side
    expect(gameState.players[0].getStatus(GameConstants.suspects.first), isNot(DeductionStatus.unknown));
  });
}
