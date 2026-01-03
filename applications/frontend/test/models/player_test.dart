import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/models/game_constants.dart';

void main() {
  group('Player Tests', () {
    test('Initial status should be unknown', () {
      final player = Player(name: 'Test Player');
      expect(player.getStatus(GameConstants.suspects.first), DeductionStatus.unknown);
    });

    test('setStatus updates the status of a card', () {
      final player = Player(name: 'Test Player');
      final card = GameConstants.suspects.first;

      player.setStatus(card, DeductionStatus.hasIt);
      expect(player.getStatus(card), DeductionStatus.hasIt);

      player.setStatus(card, DeductionStatus.doesNotHaveIt);
      expect(player.getStatus(card), DeductionStatus.doesNotHaveIt);
    });

    test('Card statuses are independent', () {
      final player = Player(name: 'Test Player');
      final card1 = GameConstants.suspects[0];
      final card2 = GameConstants.suspects[1];

      player.setStatus(card1, DeductionStatus.hasIt);
      expect(player.getStatus(card1), DeductionStatus.hasIt);
      expect(player.getStatus(card2), DeductionStatus.unknown);
    });
  });
}
