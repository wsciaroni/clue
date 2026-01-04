import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/screens/turn_form.dart';
import 'package:frontend/state/game_state.dart';

void main() {
  testWidgets('TurnForm renders correctly when a Room is shown', (WidgetTester tester) async {
    final player1 = Player(name: 'Player 1');
    final player2 = Player(name: 'Player 2');

    // Suggestion: Mustard, Knife, Hall.
    // Shown: Hall.
    final turn = GameTurn(
      askingPlayer: player1,
      answeringPlayer: player2,
      suspect: GameConstants.suspects.firstWhere((c) => c.name == 'Colonel Mustard'),
      weapon: GameConstants.weapons.firstWhere((c) => c.name == 'Knife'),
      room: GameConstants.rooms.firstWhere((c) => c.name == 'Hall'),
      cardShown: true,
      specificCardShown: GameConstants.rooms.firstWhere((c) => c.name == 'Hall'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TurnForm(
            players: [player1, player2],
            onSubmit: (_) {},
            initialTurn: turn,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify no crash and correct values
    expect(find.text('Hall'), findsNWidgets(2)); // One in "Room" dropdown, one in "Which card?" dropdown
  });

  testWidgets('TurnForm automatically updates specificCardShown when parent dropdown changes', (WidgetTester tester) async {
    final player1 = Player(name: 'Player 1');
    final player2 = Player(name: 'Player 2');

    // Initial: Mustard, Knife, Hall. Shown: Hall.
    final turn = GameTurn(
      askingPlayer: player1,
      answeringPlayer: player2,
      suspect: GameConstants.suspects.firstWhere((c) => c.name == 'Colonel Mustard'),
      weapon: GameConstants.weapons.firstWhere((c) => c.name == 'Knife'),
      room: GameConstants.rooms.firstWhere((c) => c.name == 'Hall'),
      cardShown: true,
      specificCardShown: GameConstants.rooms.firstWhere((c) => c.name == 'Hall'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TurnForm(
            players: [player1, player2],
            onSubmit: (_) {},
            initialTurn: turn,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial state
    expect(find.text('Hall'), findsNWidgets(2));

    // Find the Room dropdown (the first one is part of the form, likely the 4th dropdown in column)
    // Order: WhoAsked, Suspect, Weapon, Room, WhoAnswered, CardShownDropdown

    // Let's find by label
    // Note: DropdownButtonFormField doesn't easily expose the label for finding the tap target,
    // but we can find the widget with the value "Hall" that is NOT the last one.
    // Or just tap the one that says "Hall".
    // Since there are 2 widgets with text "Hall", and the first one is likely the "Room" dropdown.

    // To be precise:
    final hallTexts = find.text('Hall');
    // First instance should be the selected item in Room dropdown.
    await tester.tap(hallTexts.first);
    await tester.pumpAndSettle();

    // Select "Lounge"
    await tester.tap(find.text('Lounge').last); // .last because it might be in the list? Usually unique in popup.
    await tester.pumpAndSettle();

    // Now, Room should be Lounge.
    // And "Which card?" should ALSO be Lounge.
    expect(find.text('Lounge'), findsNWidgets(2));

    // Verify Hall is gone (or only in the list if we opened it, but we closed it)
    expect(find.text('Hall'), findsNothing);
  });
}
