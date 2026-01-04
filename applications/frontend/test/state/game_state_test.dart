import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/services/clue_client.dart';
import 'package:frontend/state/game_state.dart';
import 'package:frontend/generated/clue.pb.dart' as proto;

class MockClueClient extends ClueClient {
  int fetchGameStateCallCount = 0;

  @override
  Future<void> initializeGame(
    List<String> players,
    List<GameCard> userHand,
  ) async {
    // Mock successful initialization
    return;
  }

  @override
  Future<proto.GameStateResponse> fetchGameState() async {
    fetchGameStateCallCount++;
    // Return a dummy response with some solution probabilities to verify parsing
    final response = proto.GameStateResponse();

    // Add a probability for Colonel Mustard
    final prob = proto.SolutionProbability()
      ..card = (proto.Card()
        ..type = proto.CardType.CARD_TYPE_SUSPECT
        ..suspect = proto.Suspect.SUSPECT_COL_MUSTARD)
      ..probability = 0.5
      ..isEliminated = false;

    response.solutionProbabilities.add(prob);

    return response;
  }
}

void main() {
  group('GameState Tests', () {
    late GameState gameState;
    late MockClueClient mockClient;

    setUp(() {
      mockClient = MockClueClient();
      gameState = GameState(client: mockClient);
    });

    test('startGame fetches game state immediately', () async {
      final players = ['User', 'Player2'];
      final userHand = <GameCard>[];

      await gameState.startGame(players, userHand);

      // Verify fetchGameState was called
      expect(mockClient.fetchGameStateCallCount, 1,
        reason: 'fetchGameState should be called exactly once after start game');

      // Verify solution probabilities were updated (based on mock data)
      expect(gameState.solutionProbabilities.length, 1);
      expect(gameState.solutionProbabilities.first.card.name, 'Colonel Mustard');
    });
  });
}
