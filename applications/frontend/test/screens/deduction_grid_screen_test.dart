import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/screens/deduction_grid_screen.dart';
import 'package:frontend/state/game_state.dart';

// Mock GameState to avoid backend calls
class MockGameState extends ChangeNotifier implements GameState {
  @override
  final List<Player> players = [
    Player(name: 'Player 1'),
    Player(name: 'Player 2'),
  ];

  @override
  bool get gameStarted => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('DeductionGridScreen displays correctly with new layout', (WidgetTester tester) async {
    // Set a larger surface size to ensure all elements render
    await tester.binding.setSurfaceSize(const Size(800, 1600));

    // Arrange
    final mockGameState = MockGameState();
    // Set a status to verify icons
    mockGameState.players[0].setStatus(GameConstants.suspects[0], DeductionStatus.hasIt);
    mockGameState.players[1].setStatus(GameConstants.suspects[0], DeductionStatus.doesNotHaveIt);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<GameState>.value(
          value: mockGameState,
          child: const Scaffold(body: DeductionGridScreen()),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    // Verify Header
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('Player 1'), findsOneWidget);
    expect(find.text('Player 2'), findsOneWidget);

    // Verify Categories
    expect(find.text('SUSPECTS'), findsOneWidget);
    expect(find.text('WEAPONS'), findsOneWidget);
    expect(find.text('ROOMS'), findsOneWidget);

    // Verify Content
    expect(find.text('Colonel Mustard'), findsOneWidget);

    // Verify Icons
    expect(find.byIcon(Icons.check), findsWidgets); // Should find at least one
    expect(find.byIcon(Icons.close), findsWidgets); // Should find at least one
  });
}
