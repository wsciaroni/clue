import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/turn_form.dart';
import 'package:frontend/state/game_state.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/recommendation.dart';
import 'package:frontend/models/solution_probability.dart';

class MockGameState extends ChangeNotifier implements GameState {
  @override
  List<Player> get players => [Player(name: 'Player 1')];

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

  @override
  void updateConnectionSettings(String? host, int? port) {}

  @override
  Future<List<Recommendation>> getSuggestions({String? roomName}) async => [];

  @override
  Future<Recommendation?> getAccusationRecommendation() async => null;
}

void main() {
  testWidgets('TurnForm displays different recommendation buttons based on mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<GameState>(
            create: (_) => MockGameState(),
            child: TurnForm(
              players: [Player(name: 'Player 1')],
              onSubmit: (turn) {},
            ),
          ),
        ),
      ),
    );

    // Initial state: Suggestion mode
    // Should see "Room Hint" and "All Hints"
    expect(find.text('Room Hint'), findsOneWidget);
    expect(find.text('All Hints'), findsOneWidget);
    expect(find.text('Recommend Accusation'), findsNothing);

    // "Room Hint" should be disabled initially (no room selected)
    // Finding TextButton and checking enabled state is tricky directly,
    // but we can check if the onPressed is null or effectively disabled by tap.
    // However, Flutter tests usually rely on semantics or direct widget inspection.
    // Finding TextButton and checking enabled state
    // The "Room Hint" button might be an icon button or specialized widget,
    // but the implementation uses TextButton.icon which renders a TextButton.
    // However, if the ancestor search is ambiguous or failing, we can try finding by icon + text.

    // Let's verify we found exactly one widget with text 'Room Hint'
    expect(find.text('Room Hint'), findsOneWidget);

    // Because TextButton.icon uses a different internal structure (it might wrap the label differently),
    // find.widgetWithText(TextButton, ...) works reliably in most cases, but let's try a direct approach
    // if finding by ancestor fails.
    //
    // However, since we are using TextButton.icon, the structure is TextButton -> ButtonStyleButton -> ... -> Row -> [Icon, SizedBox, Text].
    // So Text is a descendant of TextButton.

    // Finding TextButton by text.
    // TextButton.icon is composed of a TextButton containing a Row (usually).
    // The previous finder strategies were failing. Let's try finding by the Icon which is unique to this button in the current view.
    // The button has Icon(Icons.lightbulb).

    // Finding TextButton that contains the specific icon and the specific text.
    // Or just finding the button by icon since there is another one with list_alt.

    // Finding the disabled button directly using predicate
    final disabledButtonFinder = find.byWidgetPredicate(
      (widget) => widget is TextButton && widget.onPressed == null
    );

    expect(disabledButtonFinder, findsOneWidget, reason: "Should find exactly one disabled TextButton (Room Hint)");

    // We can also verify that the 'Room Hint' text is present
    expect(find.text('Room Hint'), findsOneWidget);

    // Select a room
    await tester.tap(find.widgetWithText(DropdownButtonFormField<GameCard>, 'Room'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kitchen').last);
    await tester.pumpAndSettle();

    // Re-find the button as widget tree has rebuilt.
    // Now both should be enabled.
    // We check that we CANNOT find a disabled button anymore.
    final textButtonsEnabled = tester.widgetList<TextButton>(find.byType(TextButton));
    bool foundDisabled = false;
    for (var btn in textButtonsEnabled) {
      if (btn.onPressed == null) {
        foundDisabled = true;
        break;
      }
    }
    expect(foundDisabled, isFalse, reason: "All buttons should be enabled");

    // Switch to Accusation mode
    await tester.tap(find.text('Accusation'));
    await tester.pumpAndSettle();

    // Should see "Recommend Accusation"
    expect(find.text('Recommend Accusation'), findsOneWidget);
    expect(find.text('Room Hint'), findsNothing);
    expect(find.text('All Hints'), findsNothing);
  });
}
