import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/recommendation.dart';

void main() {
  test('Recommendation model toString', () {
    final rec = Recommendation(
      suspect: GameConstants.suspects[0], // Mustard
      weapon: GameConstants.weapons[0],   // Candlestick
      room: GameConstants.rooms[0],       // Kitchen
      benefit: 0.5,
    );
    expect(
        rec.toString(), contains('Recommendation(suspect: Colonel Mustard, weapon: Candlestick, room: Kitchen, benefit: 0.5)'));
  });
}
