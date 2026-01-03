import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/state/game_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Integration Test: Full Game Flow', (WidgetTester tester) async {
    // 1. Setup
    final gameState = GameState();
    await tester.binding.setSurfaceSize(const Size(800, 1200));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: gameState,
        child: const MaterialApp(home: AppOrchestrator()),
      ),
    );

    // Verify on Setup Screen
    expect(find.text('Clue Setup'), findsOneWidget);

    // 2. Start Game (Minimal setup)
    // Scroll to Start Game
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();

    // Verify we are on Game Log Screen (Home)
    expect(find.text('Clue Assistant'), findsOneWidget);
    expect(find.text('Game Log'), findsOneWidget);
    expect(find.text('Record Turn'), findsOneWidget);

    // 3. Record a Turn
    // Asker: User (First in list)
    // Suspect: Mustard
    // Weapon: Candlestick
    // Room: Kitchen
    // Answerer: Player 2
    // No card shown

    // Helper to select dropdown value
    Future<void> selectDropdown(String label, String value) async {
      // Find and tap the dropdown trigger (InputDecorator with label)
      await tester.scrollUntilVisible(find.text(label), 500, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      // Tap the item in the menu
      await tester.tap(find.text(value).last);
      await tester.pumpAndSettle();
    }

    // "Who Asked?"
    await selectDropdown('Who Asked?', 'Me');

    // "Suspect"
    await selectDropdown('Suspect', GameConstants.suspects[0].name);

    // "Weapon"
    await selectDropdown('Weapon', GameConstants.weapons[0].name);

    // "Room"
    await selectDropdown('Room', GameConstants.rooms[0].name);

    // "Who Answered?"
    await selectDropdown('Who Answered?', 'Player 2');

    // Submit
    await tester.tap(find.text('Submit Turn'));
    await tester.pumpAndSettle();

    // Verify Log
    expect(find.textContaining('Me asked Player 2'), findsOneWidget);

    // Verify State Deduction
    // Player 2 showed no card -> Doesn't have Mustard, Candlestick, Kitchen
    final player2 = gameState.players.firstWhere((p) => p.name == 'Player 2');
    expect(player2.getStatus(GameConstants.suspects[0]), isNot(DeductionStatus.unknown));
  });
}
