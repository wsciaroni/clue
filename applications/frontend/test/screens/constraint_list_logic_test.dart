import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/state/game_state.dart';

void main() {
  group('Constraint List Logic', () {
    late Player playerA;
    late Player playerB;
    late Player playerC;

    setUp(() {
      playerA = Player(name: 'Player A');
      playerB = Player(name: 'Player B');
      playerC = Player(name: 'Player C');
    });

    test(
      'Filter returns only turns where card was shown (answeringPlayer != null)',
      () {
        // Create mixed turns
        final turn1 = GameTurn(
          askingPlayer: playerA,
          answeringPlayer: playerB, // Someone answered
          suspect: GameConstants.suspects[0],
          weapon: GameConstants.weapons[0],
          room: GameConstants.rooms[0],
        );

        final turn2 = GameTurn(
          askingPlayer: playerA,
          answeringPlayer: null, // No one answered
          suspect: GameConstants.suspects[1],
          weapon: GameConstants.weapons[1],
          room: GameConstants.rooms[1],
        );

        final turns = [turn1, turn2];

        // Updated Logic: Check if answeringPlayer is not null
        final constraints = turns
            .where((t) => t.answeringPlayer != null)
            .toList();

        expect(constraints.length, 1);
        expect(constraints.first, turn1);
      },
    );

    test('Resolved status check logic', () {
      final turn = GameTurn(
        askingPlayer: playerA,
        answeringPlayer: playerB,
        suspect: GameConstants.suspects[0], // Col Mustard
        weapon: GameConstants.weapons[0], // Knife
        room: GameConstants.rooms[0], // Hall
      );

      // Helper function to simulate the logic in ConstraintListScreen
      bool isResolved(GameTurn t) {
        if (t.specificCardShown != null) return true;

        // Safe because we only check resolved status on turns where someone answered
        final p = t.answeringPlayer!;

        if (p.getStatus(t.suspect) == DeductionStatus.hasIt) return true;
        if (p.getStatus(t.weapon) == DeductionStatus.hasIt) return true;
        if (p.getStatus(t.room) == DeductionStatus.hasIt) return true;
        return false;
      }

      // Initial state: Unknown
      expect(isResolved(turn), false);

      // Case 1: We know they have one of the cards (Mustard)
      playerB.setStatus(GameConstants.suspects[0], DeductionStatus.hasIt);
      expect(isResolved(turn), true);

      // Reset
      playerB.setStatus(GameConstants.suspects[0], DeductionStatus.unknown);
      expect(isResolved(turn), false);

      // Case 2: We know the specific card shown
      final specificTurn = GameTurn(
        askingPlayer: playerA,
        answeringPlayer: playerB,
        suspect: GameConstants.suspects[0],
        weapon: GameConstants.weapons[0],
        room: GameConstants.rooms[0],
        specificCardShown: GameConstants.weapons[0],
      );
      expect(isResolved(specificTurn), true);
    });

    test('Grouping Logic', () {
      final turn1 = GameTurn(
        askingPlayer: playerA,
        answeringPlayer: playerB,
        suspect: GameConstants.suspects[0],
        weapon: GameConstants.weapons[0],
        room: GameConstants.rooms[0],
      );

      final turn2 = GameTurn(
        askingPlayer: playerB,
        answeringPlayer: playerA,
        suspect: GameConstants.suspects[1],
        weapon: GameConstants.weapons[1],
        room: GameConstants.rooms[1],
      );

      final turn3 = GameTurn(
        askingPlayer: playerC,
        answeringPlayer: playerB,
        suspect: GameConstants.suspects[2],
        weapon: GameConstants.weapons[2],
        room: GameConstants.rooms[2],
      );

      final constraints = [turn1, turn2, turn3];

      // Group by Answerer
      final byAnswerer = <Player, List<GameTurn>>{};
      for (var t in constraints) {
        // We assume logic only runs on filtered list where answerer != null
        if (t.answeringPlayer != null) {
          byAnswerer.putIfAbsent(t.answeringPlayer!, () => []).add(t);
        }
      }

      expect(byAnswerer.keys.length, 2);
      expect(byAnswerer[playerB]!.length, 2); // turn1, turn3
      expect(byAnswerer[playerA]!.length, 1); // turn2

      // Group by Asker
      final byAsker = <Player, List<GameTurn>>{};
      for (var t in constraints) {
        byAsker.putIfAbsent(t.askingPlayer, () => []).add(t);
      }

      expect(byAsker.keys.length, 3);
      expect(byAsker[playerA]!.length, 1);
      expect(byAsker[playerB]!.length, 1);
      expect(byAsker[playerC]!.length, 1);
    });
  });
}
