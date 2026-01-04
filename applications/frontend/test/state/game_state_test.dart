import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/state/game_state.dart';

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
        answeringPlayer: null,
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

  group('GameState Deduction Tests', () {
    test('recordTurn applies "doesNotHaveIt" to all players when no one answers', () async {
      final gameState = GameState();

      // Setup players
      final p1 = Player(name: 'Alice');
      final p2 = Player(name: 'Bob');
      final p3 = Player(name: 'Charlie');

      // Hacky way to set players since startGame involves backend
      // We can't easily mock ClueClient inside GameState without DI or overrides.
      // However, deduction logic happens *before* client calls in recordTurn (partially).
      // But wait, recordTurn calls _client.submitTurn.
      // If we run this test, it will likely fail due to _client connection unless we mock it.

      // Since `GameState` instantiates `ClueClient` directly, unit testing it in isolation is hard without refactoring for DI.
      // BUT, let's look at `recordTurn`:
      /*
      Future<void> recordTurn(GameTurn turn) async {
        _turnLog.insert(0, turn);

        if (turn.answeringPlayer == null) {
           // Deduction Logic
        }
        notifyListeners();

        try {
          await _client.submitTurn(turn);
          // ...
        } catch (e) { ... }
      }
      */
      // The deduction logic runs *before* the client call.
      // The client call inside try-catch will fail (catch block), but that shouldn't crash the test if we expect it.
      // However, we need `_players` to be populated. `startGame` populates it but also calls `_client.initializeGame`.

      // We might need to rely on the fact that `startGame` also has a try-catch block.

      await gameState.startGame(['Alice', 'Bob', 'Charlie'], []);

      final suspect = GameConstants.suspects[0]; // Mustard
      final weapon = GameConstants.weapons[0]; // Knife
      final room = GameConstants.rooms[0]; // Hall

      final turn = GameTurn(
        askingPlayer: gameState.players[0], // Alice
        suspect: suspect,
        weapon: weapon,
        room: room,
        answeringPlayer: null, // No one answered
      );

      await gameState.recordTurn(turn);

      // Verify deductions
      // Bob and Charlie should NOT have these cards
      expect(gameState.players[1].getStatus(suspect), DeductionStatus.doesNotHaveIt);
      expect(gameState.players[1].getStatus(weapon), DeductionStatus.doesNotHaveIt);
      expect(gameState.players[1].getStatus(room), DeductionStatus.doesNotHaveIt);

      expect(gameState.players[2].getStatus(suspect), DeductionStatus.doesNotHaveIt);
      expect(gameState.players[2].getStatus(weapon), DeductionStatus.doesNotHaveIt);
      expect(gameState.players[2].getStatus(room), DeductionStatus.doesNotHaveIt);

      // Alice (Asker) status remains unknown (or whatever it was)
      // Actually, logic says "if p != turn.askingPlayer".
      expect(gameState.players[0].getStatus(suspect), isNot(DeductionStatus.doesNotHaveIt));
    });
  });
}
