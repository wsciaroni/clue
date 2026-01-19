import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/models/solution_probability.dart';
import 'package:frontend/screens/setup_screen.dart';
import 'package:frontend/state/game_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Mock Classes ---
class MockGameState extends ChangeNotifier implements GameState {
  @override
  bool get gameStarted => false;

  @override
  List<Player> get players => [];

  @override
  List<LocalSolutionProbability> get solutionProbabilities => [];

  @override
  List<GameTurn> get turnLog => [];

  bool startCalled = false;

  @override
  Future<void> startGame(List<String> playerNames, List userHand, {List<int>? cardCounts}) async {
    startCalled = true;
  }

  @override
  void updateConnectionSettings(String? host, int? port) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SetupScreen UX Tests', () {
    late MockGameState mockGameState;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      mockGameState = MockGameState();
    });

    testWidgets('Displays card selection counter and updates on change', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<GameState>.value(
            value: mockGameState,
            child: const SetupScreen(),
          ),
        ),
      );

      // Verify initial state (Default cards is 3)
      // We expect "(Selected: 0 / 3)" to be present
      expect(find.textContaining('Selected: 0 / 3'), findsOneWidget);

      // Change card count to 4
      // We need to find the card count input for the first player (Me)
      // The label is "Cards". There are 3 default players, so 3 "Cards" fields.
      // The first one corresponds to "Me".
      final firstCardInput = find.widgetWithText(TextFormField, 'Cards').first;
      await tester.enterText(firstCardInput, '4');
      await tester.pump(); // Trigger listener

      expect(find.textContaining('Selected: 0 / 4'), findsOneWidget);

      // Select a card (e.g. Colonel Mustard)
      await tester.tap(find.text(GameConstants.suspects[0].name));
      await tester.pump();

      expect(find.textContaining('Selected: 1 / 4'), findsOneWidget);
    });

    testWidgets('Prevents start if card count mismatch', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<GameState>.value(
            value: mockGameState,
            child: const SetupScreen(),
          ),
        ),
      );

      // Default: 0 selected, 3 expected.
      // Click Start Game
      await tester.ensureVisible(find.text('Start Game'));
      await tester.tap(find.text('Start Game'));
      await tester.pump();

      // Expect SnackBar with error
      expect(find.textContaining('matches the expected count'), findsOneWidget);

      // Expect startGame NOT called
      expect(mockGameState.startCalled, isFalse);
    });
  });
}
