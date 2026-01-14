import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/setup_screen.dart';
import 'package:frontend/state/game_state.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/solution_probability.dart';

// Mock GameState since SetupScreen needs it
class MockGameState extends ChangeNotifier implements GameState {
  @override
  List<Player> get players => [];
  @override
  List<GameTurn> get turnLog => [];
  @override
  bool get gameStarted => false;
  @override
  List<LocalSolutionProbability> get solutionProbabilities => [];
  @override
  Future<void> recordTurn(GameTurn turn) async {}
  @override
  Future<void> deleteTurn(GameTurn turn) async {}

  @override
  Future<void> startGame(List<String> playerNames, List<GameCard> userHand, {List<int>? cardCounts}) async {
    // Mock implementation
  }

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
  testWidgets('SetupScreen shows card counts in section headers', (WidgetTester tester) async {
    // Provide a sufficient surface size
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<GameState>(
          create: (_) => MockGameState(),
          child: const SetupScreen(),
        ),
      ),
    );

    // Verify initial state: counts should be 0
    expect(find.text('Suspects (0)'), findsOneWidget);
    expect(find.text('Weapons (0)'), findsOneWidget);
    expect(find.text('Rooms (0)'), findsOneWidget);

    // Find a suspect chip and tap it.
    // We'll use the first suspect from GameConstants
    final firstSuspectName = GameConstants.suspects.first.name;
    await tester.tap(find.text(firstSuspectName));
    await tester.pumpAndSettle();

    // Verify count updated to 1
    expect(find.text('Suspects (1)'), findsOneWidget);

    // Tap another suspect
    final secondSuspectName = GameConstants.suspects[1].name;
    await tester.tap(find.text(secondSuspectName));
    await tester.pumpAndSettle();

    // Verify count updated to 2
    expect(find.text('Suspects (2)'), findsOneWidget);

    // Tap the first one again to deselect
    await tester.tap(find.text(firstSuspectName));
    await tester.pumpAndSettle();

    // Verify count goes back to 1
    expect(find.text('Suspects (1)'), findsOneWidget);
  });
}
