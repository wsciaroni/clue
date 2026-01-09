import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/services/clue_client.dart';
import 'package:frontend/state/game_state.dart';
import 'package:frontend/generated/clue.pb.dart' as proto;

// --- Mock Classes ---

class MockClueClient extends ClueClient {
  int fetchGameStateCallCount = 0;

  @override
  Future<void> initializeGame(
    List<String> players,
    List<GameCard> userHand, {
    List<int>? cardCounts,
  }) async {
    return;
  }

  @override
  Future<void> submitTurn(GameTurn turn) async {
    // Mock successful submission
    return;
  }

  @override
  Future<proto.GameStateResponse> fetchGameState() async {
    fetchGameStateCallCount++;
    // Return a dummy response to verify parsing
    final response = proto.GameStateResponse();

    final prob = proto.SolutionProbability()
      ..card = (proto.Card()
        ..type = proto.CardType.CARD_TYPE_SUSPECT
        ..suspect = proto.Suspect.SUSPECT_COL_MUSTARD)
      ..probability = 0.5
      ..isEliminated = false;

    response.solutionProbabilities.add(prob);

    // If this is the second call (triggered by recordTurn in the test),
    // return the expected deductions for the "no one answered" scenario.
    if (fetchGameStateCallCount > 1) {
      void addRow(proto.Card card) {
        final row = proto.GridRow()..card = card;
        // Alice (Asker) - status unaffected/unknown
        row.playerStates
            .add(proto.CellState()..status = proto.CellState_Status.UNKNOWN);
        // Bob - Does Not Have
        row.playerStates.add(
            proto.CellState()..status = proto.CellState_Status.DOES_NOT_HAVE);
        // Charlie - Does Not Have
        row.playerStates.add(
            proto.CellState()..status = proto.CellState_Status.DOES_NOT_HAVE);
        response.rows.add(row);
      }

      // Col Mustard
      addRow(proto.Card()
        ..type = proto.CardType.CARD_TYPE_SUSPECT
        ..suspect = proto.Suspect.SUSPECT_COL_MUSTARD);
      // Candlestick (Index 0)
      addRow(proto.Card()
        ..type = proto.CardType.CARD_TYPE_WEAPON
        ..weapon = proto.Weapon.WEAPON_CANDLESTICK);
      // Kitchen (Index 0)
      addRow(proto.Card()
        ..type = proto.CardType.CARD_TYPE_ROOM
        ..room = proto.Room.ROOM_KITCHEN);
    }

    return response;
  }

  @override
  Future<List<proto.TurnEntry>> getTurnHistory() async {
    return [];
  }
}

// --- Main Entry Point ---

void main() {
  group('GameTurn Tests', () {
    test('GameTurn toString() handles null answeringPlayer', () {
      final p1 = Player(name: 'Alice');
      final suspect = GameConstants.suspects.first;
      final weapon = GameConstants.weapons.first;
      final room = GameConstants.rooms.first;

      final turn = GameTurn(
        askingPlayer: p1,
        suspect: suspect,
        weapon: weapon,
        room: room,
        answeringPlayer: null, // Logic: null means no one answered
      );

      expect(turn.toString(), contains('No one answered'));
    });

    test('GameTurn toString() handles answeringPlayer with specific card', () {
      final p1 = Player(name: 'Alice');
      final p2 = Player(name: 'Bob');
      final suspect = GameConstants.suspects.first;
      final weapon = GameConstants.weapons.first;
      final room = GameConstants.rooms.first;

      final turn = GameTurn(
        askingPlayer: p1,
        suspect: suspect,
        weapon: weapon,
        room: room,
        answeringPlayer: p2,
        specificCardShown: suspect,
      );

      expect(turn.toString(), contains('Bob'));
      expect(turn.toString(), contains(suspect.name));
    });
  });

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

      expect(
        mockClient.fetchGameStateCallCount,
        1,
        reason: 'fetchGameState should be called exactly once after start game',
      );

      expect(gameState.solutionProbabilities.length, 1);
      expect(
        gameState.solutionProbabilities.first.card.name,
        'Colonel Mustard',
      );
    });

    test(
      'recordTurn applies "doesNotHaveIt" to all players when no one answers',
      () async {
        // Initialize state
        await gameState.startGame(['Alice', 'Bob', 'Charlie'], []);

        final suspect = GameConstants.suspects[0];
        final weapon = GameConstants.weapons[0];
        final room = GameConstants.rooms[0];

        final turn = GameTurn(
          askingPlayer: gameState.players[0], // Alice
          suspect: suspect,
          weapon: weapon,
          room: room,
          answeringPlayer: null, // "No one answered"
        );

        // Record the turn
        await gameState.recordTurn(turn);

        // Verify deductions:
        // Since no one answered Alice, both Bob (1) and Charlie (2) do not have the cards.

        // Bob
        expect(
          gameState.players[1].getStatus(suspect),
          DeductionStatus.doesNotHaveIt,
        );
        expect(
          gameState.players[1].getStatus(weapon),
          DeductionStatus.doesNotHaveIt,
        );
        expect(
          gameState.players[1].getStatus(room),
          DeductionStatus.doesNotHaveIt,
        );

        // Charlie
        expect(
          gameState.players[2].getStatus(suspect),
          DeductionStatus.doesNotHaveIt,
        );
        expect(
          gameState.players[2].getStatus(weapon),
          DeductionStatus.doesNotHaveIt,
        );
        expect(
          gameState.players[2].getStatus(room),
          DeductionStatus.doesNotHaveIt,
        );

        // Alice (Asker) status should remain unaffected
        expect(
          gameState.players[0].getStatus(suspect),
          isNot(DeductionStatus.doesNotHaveIt),
        );
      },
    );
  });
}
