import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/state/game_state.dart';
import 'package:frontend/generated/clue.pb.dart' as proto;
import 'package:mockito/mockito.dart';
import 'manual_mocks.dart';

void main() {
  group('GameState Connection Management', () {
    late MockClueClient mockClient;
    late GameState gameState;

    setUp(() {
      mockClient = MockClueClient();
      gameState = GameState(client: mockClient);
    });

    test('Initial status is disconnected', () {
      expect(gameState.connectionStatus, BackendStatus.disconnected);
    });

    test('startGame sets status to connected on success', () async {
      when(mockClient.initializeGame(any, any, cardCounts: anyNamed('cardCounts')))
          .thenAnswer((_) async {});
      when(mockClient.fetchGameState())
          .thenAnswer((_) async => proto.GameStateResponse()..gameId = "123");

      await gameState.startGame(['Player1', 'Player2'], []);

      expect(gameState.connectionStatus, BackendStatus.connected);
    });

    test('startGame sets status to disconnected on failure', () async {
      when(mockClient.initializeGame(any, any, cardCounts: anyNamed('cardCounts')))
          .thenThrow(Exception("Network Error"));

      await gameState.startGame(['Player1', 'Player2'], []);

      expect(gameState.connectionStatus, BackendStatus.disconnected);
    });

    test('checkConnection triggers restore when gameId is empty', () async {
      // 1. Start game successfully
      when(mockClient.initializeGame(any, any, cardCounts: anyNamed('cardCounts')))
          .thenAnswer((_) async {});
      when(mockClient.fetchGameState())
          .thenAnswer((_) async => proto.GameStateResponse()..gameId = "123");

      await gameState.startGame(['Player1', 'Player2'], []);
      expect(gameState.connectionStatus, BackendStatus.connected);

      // 2. Simulate Heartbeat where game is missing (Empty gameId)
      when(mockClient.fetchGameState())
          .thenAnswer((_) async => proto.GameStateResponse()); // Empty gameId

      // 3. Stub the re-initialization calls
      when(mockClient.initializeGame(any, any, cardCounts: anyNamed('cardCounts')))
          .thenAnswer((_) async {});
      // Note: submitTurn is not called because turnLog is empty in this test case

      // 4. Trigger check
      await gameState.checkConnectionForTesting();

      // 5. Verify it attempted to restore and ended up connected
      verify(mockClient.initializeGame(any, any, cardCounts: anyNamed('cardCounts'))).called(2); // Once for start, once for restore
      expect(gameState.connectionStatus, BackendStatus.connected);
    });

    // Test Restoration Logic (simulated)
    // Note: Since _checkConnection is private and timer-based, it's hard to test directly without exposing it.
    // However, we can simulate the condition that triggers restoration if we could call the logic.
    // Given the constraints, we rely on the implementation correctness for the private timer logic
    // and focus on `startGame` setting the baseline.

    // Ideally we would export `checkConnection` for testing or use `@visibleForTesting`.
  });
}
