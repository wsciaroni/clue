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

  testWidgets('TurnForm renders correctly when a Suspect is shown', (WidgetTester tester) async {
    final player1 = Player(name: 'Player 1');
    final player2 = Player(name: 'Player 2');

    final turn = GameTurn(
      askingPlayer: player1,
      answeringPlayer: player2,
      suspect: GameConstants.suspects.firstWhere((c) => c.name == 'Colonel Mustard'),
      weapon: GameConstants.weapons.firstWhere((c) => c.name == 'Knife'),
      room: GameConstants.rooms.firstWhere((c) => c.name == 'Hall'),
      cardShown: true,
      specificCardShown: GameConstants.suspects.firstWhere((c) => c.name == 'Colonel Mustard'),
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

    expect(find.text('Colonel Mustard'), findsNWidgets(2));
  });

  testWidgets('TurnForm renders correctly when a Weapon is shown', (WidgetTester tester) async {
    final player1 = Player(name: 'Player 1');
    final player2 = Player(name: 'Player 2');

    final turn = GameTurn(
      askingPlayer: player1,
      answeringPlayer: player2,
      suspect: GameConstants.suspects.firstWhere((c) => c.name == 'Colonel Mustard'),
      weapon: GameConstants.weapons.firstWhere((c) => c.name == 'Knife'),
      room: GameConstants.rooms.firstWhere((c) => c.name == 'Hall'),
      cardShown: true,
      specificCardShown: GameConstants.weapons.firstWhere((c) => c.name == 'Knife'),
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

    expect(find.text('Knife'), findsNWidgets(2));
  });
}
