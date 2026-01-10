import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/game_home.dart';
import 'package:frontend/state/game_state.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/solution_probability.dart';

class MockGameState extends ChangeNotifier implements GameState {
  @override
  List<Player> get players => [
        Player(name: 'Player 1'),
        Player(name: 'Player 2'),
      ];

  @override
  List<GameTurn> get turnLog => [];

  @override
  bool get gameStarted => true;

  @override
  List<LocalSolutionProbability> get solutionProbabilities => [];

  @override
  Future<void> recordTurn(GameTurn turn) async {}

  @override
  Future<void> deleteTurn(GameTurn turn) async {}

  @override
  Future<void> startGame(List<String> playerNames, List<GameCard> userHand, {List<int>? cardCounts}) async {}

  @override
  void reset() {}

  @override
  String toJson() => "{}";

  @override
  // ignore: override_on_non_overriding_member
  void fromJson(String json) {}

  @override
  Future<void> updateTurn(GameTurn turn) async {}

  @override
  // ignore: override_on_non_overriding_member
  GameTurn? get lastDeletedTurn => null;

  @override
  // ignore: override_on_non_overriding_member
  Future<void> undoDeleteTurn() async {}

  @override
  // ignore: override_on_non_overriding_member
  Future<void> undoLastTurn() async {}

  @override
  Future<void> loadGame(String jsonString) async {}

}

void main() {
  testWidgets('TurnForm inputs persist when switching tabs', (WidgetTester tester) async {
    // Provide a sufficient surface size
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<GameState>(
          create: (_) => MockGameState(),
          child: const GameHome(),
        ),
      ),
    );

    // Initial state: Game Log screen should be visible
    expect(find.text('Record Turn'), findsOneWidget);
    expect(find.text('Who Asked?'), findsOneWidget);

    // Enter data into the form
    // Tap "Who Asked?" dropdown
    await tester.tap(find.widgetWithText(DropdownButtonFormField<Player>, 'Who Asked?'));
    await tester.pumpAndSettle();

    // Select "Player 1"
    await tester.tap(find.text('Player 1').last);
    await tester.pumpAndSettle();

    // Verify selection
    expect(find.text('Player 1'), findsOneWidget);

    // Switch to "Deduction Grid" tab (index 1)
    await tester.tap(find.byIcon(Icons.grid_on));
    await tester.pumpAndSettle();

    // Verify we are on Deduction Grid
    expect(find.text('Deduction Grid'), findsWidgets);

    // Ensure Record Turn is NOT visible (because it's offstage)
    expect(find.text('Record Turn'), findsNothing);

    // Switch back to "Game Log" tab (index 0)
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    // Verify we are back
    expect(find.text('Record Turn'), findsOneWidget);

    // Verify "Player 1" is still selected
    expect(find.text('Player 1'), findsOneWidget);

    // Select a suspect to be sure
    await tester.tap(find.widgetWithText(DropdownButtonFormField<GameCard>, 'Suspect'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(GameConstants.suspects[0].name).last);
    await tester.pumpAndSettle();

    // Switch away and back again
    await tester.tap(find.byIcon(Icons.grid_on));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    // Verify suspect is still selected
    expect(find.text(GameConstants.suspects[0].name), findsOneWidget);
  });
}
