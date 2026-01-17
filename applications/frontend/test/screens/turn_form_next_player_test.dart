import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/models/recommendation.dart';
import 'package:frontend/screens/turn_form.dart';
import 'package:frontend/state/game_state.dart';
import 'package:provider/provider.dart';

// Mock GameState is not strictly needed for TurnForm structure if we just test UI state,
// but TurnForm uses context.read<GameState>() for recommendations.
// We should provide a mock or a dummy provider.
class MockGameState extends ChangeNotifier implements GameState {
  @override
  Future<List<Recommendation>> getSuggestions({String? roomName}) async => [];

  @override
  Future<Recommendation?> getAccusationRecommendation() async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('TurnForm auto-selects next player after submission', (WidgetTester tester) async {
    // Arrange
    final players = [
      Player(name: 'Player 1'),
      Player(name: 'Player 2'),
      Player(name: 'Player 3'),
    ];

    GameTurn? submittedTurn;
    void onSubmit(GameTurn turn) {
      submittedTurn = turn;
    }

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameState>(create: (_) => MockGameState()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TurnForm(
                players: players,
                onSubmit: onSubmit,
              ),
            ),
          ),
        ),
      ),
    );

    // Helper to select dropdown value
    Future<void> selectDropdown(String label, String value) async {
      // Find the dropdown by label (decoration)
      // DropdownButtonFormField has a decoration with labelText.
      // We can find the DropdownButtonFormField that contains the label.
      // Or we can tap the DropdownButton.

      // Finding by Key is hard as they don't have keys.
      // Finding by text "Who Asked?"
      final dropdownFinder = find.widgetWithText(DropdownButtonFormField<Player>, label);
      if (dropdownFinder.evaluate().isEmpty) {
        // Try finding generic dropdown if specific type fails, or by ancestor
         await tester.tap(find.text(label));
      } else {
         await tester.tap(dropdownFinder);
      }
      await tester.pumpAndSettle();

      // Tap the item
      await tester.tap(find.text(value).last);
      await tester.pumpAndSettle();
    }

    Future<void> selectGameCardDropdown(String label, String value) async {
       final dropdownFinder = find.widgetWithText(DropdownButtonFormField<GameCard>, label);
        if (dropdownFinder.evaluate().isEmpty) {
         await tester.tap(find.text(label));
      } else {
         await tester.tap(dropdownFinder);
      }
      await tester.pumpAndSettle();
      await tester.tap(find.text(value).last);
      await tester.pumpAndSettle();
    }

    // 1. Initial State: No player selected (or maybe null)
    // The code initializes _askingPlayer = null.
    // We select Player 1.
    await selectDropdown('Who Asked?', 'Player 1');

    // Select other fields to make form valid
    await selectGameCardDropdown('Suspect', GameConstants.suspects[0].name);
    await selectGameCardDropdown('Weapon', GameConstants.weapons[0].name);
    await selectGameCardDropdown('Room', GameConstants.rooms[0].name);

    // Toggle "Did someone answer?" to false to avoid selecting answering player
    await tester.tap(find.text('Did someone answer?'));
    await tester.pumpAndSettle();

    // Submit
    await tester.tap(find.text('Submit Turn'));
    await tester.pumpAndSettle();

    expect(submittedTurn, isNotNull);
    expect(submittedTurn!.askingPlayer.name, 'Player 1');

    // 2. Verify Player 2 is now selected
    // The DropdownButtonFormField should show "Player 2"
    expect(find.widgetWithText(DropdownButtonFormField<Player>, 'Player 2'), findsOneWidget);

    // 3. Submit again (We need to fill form again because it resets?)
    // TurnForm resets: _selectedSuspect = null, etc.
    // So we need to select Suspect/Weapon/Room again.
    // And toggle "Did someone answer?" again (it resets to true).

    await selectGameCardDropdown('Suspect', GameConstants.suspects[1].name);
    await selectGameCardDropdown('Weapon', GameConstants.weapons[1].name);
    await selectGameCardDropdown('Room', GameConstants.rooms[1].name);

    await tester.tap(find.text('Did someone answer?')); // Toggle off
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit Turn'));
    await tester.pumpAndSettle();

    expect(submittedTurn!.askingPlayer.name, 'Player 2');

    // 4. Verify Player 3 is now selected
    expect(find.widgetWithText(DropdownButtonFormField<Player>, 'Player 3'), findsOneWidget);

    // 5. Submit again for wrap around
    await selectGameCardDropdown('Suspect', GameConstants.suspects[2].name);
    await selectGameCardDropdown('Weapon', GameConstants.weapons[2].name);
    await selectGameCardDropdown('Room', GameConstants.rooms[2].name);

    await tester.tap(find.text('Did someone answer?')); // Toggle off
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit Turn'));
    await tester.pumpAndSettle();

    expect(submittedTurn!.askingPlayer.name, 'Player 3');

    // 6. Verify Player 1 is now selected (wrap around)
    expect(find.widgetWithText(DropdownButtonFormField<Player>, 'Player 1'), findsOneWidget);

  });
}
