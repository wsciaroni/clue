import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/state/game_state.dart';

void main() {
  group('GameState Tests', () {
    late GameState gameState;

    setUp(() {
      gameState = GameState();
    });

    test('Initial state is correct', () {
      expect(gameState.players, isEmpty);
      expect(gameState.turnLog, isEmpty);
      expect(gameState.gameStarted, isFalse);
    });

    test('startGame initializes players and sets user hand', () {
      final playerNames = ['User', 'Player 2', 'Player 3'];
      final userHand = [GameConstants.suspects[0], GameConstants.weapons[0]];

      gameState.startGame(playerNames, userHand);

      expect(gameState.gameStarted, isTrue);
      expect(gameState.players.length, 3);
      expect(gameState.players.first.name, 'User');

      // Verify user hand logic
      // User has the card
      expect(gameState.players.first.getStatus(userHand[0]), DeductionStatus.hasIt);
      // Other players do not have it
      expect(gameState.players[1].getStatus(userHand[0]), DeductionStatus.doesNotHaveIt);
      expect(gameState.players[2].getStatus(userHand[0]), DeductionStatus.doesNotHaveIt);
    });

    test('recordTurn adds to log', () {
      gameState.startGame(['User', 'Player 2'], []);
      final asker = gameState.players[0];
      final answerer = gameState.players[1];

      final turn = GameTurn(
        askingPlayer: asker,
        suspect: GameConstants.suspects[0],
        weapon: GameConstants.weapons[0],
        room: GameConstants.rooms[0],
        answeringPlayer: answerer,
        cardShown: false,
      );

      gameState.recordTurn(turn);

      expect(gameState.turnLog.length, 1);
      expect(gameState.turnLog.first, turn);
    });

    test('recordTurn deduction: No card shown implies answering player does not have any', () {
      gameState.startGame(['User', 'Player 2'], []);
      final answerer = gameState.players[1];
      final suspect = GameConstants.suspects[0];
      final weapon = GameConstants.weapons[0];
      final room = GameConstants.rooms[0];

      final turn = GameTurn(
        askingPlayer: gameState.players[0],
        suspect: suspect,
        weapon: weapon,
        room: room,
        answeringPlayer: answerer,
        cardShown: false,
      );

      gameState.recordTurn(turn);

      expect(answerer.getStatus(suspect), DeductionStatus.doesNotHaveIt);
      expect(answerer.getStatus(weapon), DeductionStatus.doesNotHaveIt);
      expect(answerer.getStatus(room), DeductionStatus.doesNotHaveIt);
    });

    test('recordTurn deduction: Specific card shown implies answering player has it', () {
      gameState.startGame(['User', 'Player 2', 'Player 3'], []);
      final answerer = gameState.players[1];
      final specificCard = GameConstants.suspects[0];

      final turn = GameTurn(
        askingPlayer: gameState.players[0],
        suspect: specificCard,
        weapon: GameConstants.weapons[0],
        room: GameConstants.rooms[0],
        answeringPlayer: answerer,
        cardShown: true,
        specificCardShown: specificCard,
      );

      gameState.recordTurn(turn);

      expect(answerer.getStatus(specificCard), DeductionStatus.hasIt);
      // Other players should be marked as not having it
      expect(gameState.players[2].getStatus(specificCard), DeductionStatus.doesNotHaveIt);
    });

    test('reset clears everything', () {
      gameState.startGame(['User'], []);
      gameState.recordTurn(GameTurn(
        askingPlayer: gameState.players[0],
        suspect: GameConstants.suspects[0],
        weapon: GameConstants.weapons[0],
        room: GameConstants.rooms[0],
        answeringPlayer: gameState.players[0],
        cardShown: false,
      ));

      gameState.reset();

      expect(gameState.players, isEmpty);
      expect(gameState.turnLog, isEmpty);
      expect(gameState.gameStarted, isFalse);
    });
  });
}
