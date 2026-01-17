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
  String? host;
  int? port;

  @override
  Future<void> startGame(List<String> playerNames, List<GameCard> userHand, {List<int>? cardCounts}) async {
    startCalled = true;
  }

  @override
  void updateConnectionSettings(String? host, int? port) {
    this.host = host;
    this.port = port;
  }

  @override
  Future<void> loadGame(String content) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SetupScreen Focus Tests', () {
    late MockGameState mockGameState;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      mockGameState = MockGameState();
    });

    testWidgets('Focus moves to new player name when Add Player is clicked', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<GameState>.value(
            value: mockGameState,
            child: const SetupScreen(),
          ),
        ),
      );

      // Verify initial state: 3 players
      expect(find.text('Player 3'), findsAtLeastNWidgets(1));
      expect(find.text('Player 4'), findsNothing);

      // Tap "Add Player"
      await tester.tap(find.text('Add Player'));
      await tester.pumpAndSettle();

      // Verify Player 4 is added
      expect(find.text('Player 4'), findsAtLeastNWidgets(1));

      // Find the TextField for Player 4 name
      // Use labelText to distinguish between name and cards.
      // The name field has label "Player 4".
      // We look for a TextField (TextFormField builds TextField) that has an InputDecoration with labelText 'Player 4'.

      final finder = find.descendant(
        of: find.byType(ListView),
        matching: find.byWidgetPredicate((widget) {
          if (widget is TextField) { // TextFormField builds a TextField
             final decoration = widget.decoration;
             if (decoration?.labelText == 'Player 4') {
               return true;
             }
          }
          return false;
        }),
      );

      expect(finder, findsOneWidget);

      // Check focus
      final editableTextFinder = find.descendant(of: finder, matching: find.byType(EditableText));
      final editableText = tester.widget<EditableText>(editableTextFinder);

      expect(editableText.focusNode.hasFocus, isTrue, reason: "New player name field should have focus");
    });
  });
}
