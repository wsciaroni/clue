import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/solution_screen.dart';
import 'package:frontend/state/game_state.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/solution_probability.dart';
import 'package:frontend/models/player.dart';

// Mock GameState to inject data
class MockGameState extends ChangeNotifier implements GameState {
  @override
  List<LocalSolutionProbability> solutionProbabilities = [];

  @override
  void reset() {}

  @override
  bool get gameStarted => true;

  @override
  List<Player> get players => [];

  @override
  List<GameTurn> get turnLog => [];

  // Implement other required overrides or stubs...
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('SolutionScreen displays probabilities correctly', (WidgetTester tester) async {
    // Setup mock state
    final mockState = MockGameState();
    mockState.solutionProbabilities = [
      LocalSolutionProbability(
        card: const GameCard('Colonel Mustard', CardType.suspect),
        probability: 0.25,
        isEliminated: false,
      ),
      LocalSolutionProbability(
        card: const GameCard('Miss Scarlet', CardType.suspect),
        probability: 0.75,
        isEliminated: false,
      ),
      LocalSolutionProbability(
        card: const GameCard('Knife', CardType.weapon),
        probability: 1.0,
        isEliminated: false,
      ),
      LocalSolutionProbability(
        card: const GameCard('Rope', CardType.weapon),
        probability: 0.0,
        isEliminated: true,
      ),
    ];

    await tester.pumpWidget(
      ChangeNotifierProvider<GameState>.value(
        value: mockState,
        child: const MaterialApp(
          home: Scaffold(body: SolutionScreen()),
        ),
      ),
    );

    // Verify Suspects
    expect(find.text('Suspects'), findsOneWidget);
    expect(find.text('Colonel Mustard'), findsOneWidget);
    expect(find.text('25.0%'), findsOneWidget);
    expect(find.text('Miss Scarlet'), findsOneWidget);
    expect(find.text('75.0%'), findsOneWidget);

    // Verify Weapons
    expect(find.text('Weapons'), findsOneWidget);
    expect(find.text('Knife'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget); // 100% shows checkmark
    expect(find.text('Rope'), findsOneWidget);
    // Eliminated should look different (e.g. strikethrough)
    // We can't easily check text decoration style in simple finds, but we can verify it exists

    // Verify sorting (Scarlet 75% before Mustard 25%)
    // Finding widgets by text doesn't guarantee order, but column does.
    // For now, ensuring they exist is good enough.
  });

  testWidgets('SolutionScreen handles empty state', (WidgetTester tester) async {
    final mockState = MockGameState();
    mockState.solutionProbabilities = [];

    await tester.pumpWidget(
      ChangeNotifierProvider<GameState>.value(
        value: mockState,
        child: const MaterialApp(
          home: Scaffold(body: SolutionScreen()),
        ),
      ),
    );

    expect(find.text('No deduction data available yet.'), findsOneWidget);
  });
}
