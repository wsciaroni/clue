import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/screens/turn_form.dart';
import 'package:frontend/state/game_state.dart';

void main() {
  testWidgets('TurnForm displays icons for accessibility and UX', (WidgetTester tester) async {
    // Arrange
    final players = [
      Player(name: 'Player 1'),
      Player(name: 'Player 2'),
    ];

    // Act
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TurnForm(
          players: players,
          onSubmit: (GameTurn turn) {},
        ),
      ),
    ));

    // Assert
    // We expect icons to be present in the dropdown decorations.
    // Since DropdownButtonFormField uses InputDecoration with prefixIcon, we look for the Icons.

    // Who Asked? -> Person Icon
    expect(find.widgetWithIcon(DropdownButtonFormField<Player>, Icons.person), findsAtLeastNWidgets(1));

    // Suspect -> Person Icon
    // Note: Since both use Icons.person, we just check for multiple occurrences.
    expect(find.byIcon(Icons.person), findsAtLeastNWidgets(2));

    // Weapon -> Build Icon
    expect(find.byIcon(Icons.build), findsOneWidget);

    // Room -> Meeting Room Icon
    expect(find.byIcon(Icons.meeting_room), findsOneWidget);
  });
}
