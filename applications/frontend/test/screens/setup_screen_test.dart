import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  Future<void> startGame(List<String> playerNames, List userHand, {List<int>? cardCounts}) async {
    startCalled = true;
  }

  @override
  void updateConnectionSettings(String? host, int? port) {
    this.host = host;
    this.port = port;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SetupScreen Tests', () {
    late MockGameState mockGameState;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      mockGameState = MockGameState();
    });

    testWidgets('Renders Connection Settings ExpansionTile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<GameState>.value(
            value: mockGameState,
            child: const SetupScreen(),
          ),
        ),
      );

      expect(find.text('Connection Settings'), findsOneWidget);

      // Expand it
      await tester.tap(find.text('Connection Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Host (Optional)'), findsOneWidget);
      expect(find.text('Port (Optional)'), findsOneWidget);
    });

    testWidgets('Loads and Saves Connection Settings', (WidgetTester tester) async {
      // Set a large surface size to ensure all widgets are built/visible without scrolling
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      SharedPreferences.setMockInitialValues({
        'connection_host': '192.168.1.100',
        'connection_port': 9000
      });

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<GameState>.value(
            value: mockGameState,
            child: const SetupScreen(),
          ),
        ),
      );

      // Verify loaded values
      await tester.tap(find.text('Connection Settings'));
      await tester.pumpAndSettle();

      expect(find.text('192.168.1.100'), findsOneWidget);
      expect(find.text('9000'), findsOneWidget);

      // Change values
      await tester.enterText(find.widgetWithText(TextFormField, 'Host (Optional)'), 'localhost');
      await tester.enterText(find.widgetWithText(TextFormField, 'Port (Optional)'), '5555');

      // Start Game to trigger save
      // Need to fill required fields first (Player name is pre-filled, but let's be sure)
      await tester.ensureVisible(find.text('Start Game'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Game'));
      await tester.pump();

      // Verify GameState update called
      expect(mockGameState.host, 'localhost');
      expect(mockGameState.port, 5555);

      // Verify SharedPreferences updated
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('connection_host'), 'localhost');
      expect(prefs.getInt('connection_port'), 5555);
    });

    testWidgets('Updates connection with only Host provided', (WidgetTester tester) async {
       await tester.binding.setSurfaceSize(const Size(800, 2000));
       SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<GameState>.value(
            value: mockGameState,
            child: const SetupScreen(),
          ),
        ),
      );

      // Expand settings
      await tester.tap(find.text('Connection Settings'));
      await tester.pumpAndSettle();

      // Enter only Host
      await tester.enterText(find.widgetWithText(TextFormField, 'Host (Optional)'), '10.0.0.5');
      // Port left empty

      // Start Game
      await tester.ensureVisible(find.text('Start Game'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start Game'));
      await tester.pump();

      // Verify GameState updated with Host and Null Port
      expect(mockGameState.host, '10.0.0.5');
      expect(mockGameState.port, isNull);
    });
  });
}
