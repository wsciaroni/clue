import 'game_constants.dart';

class Recommendation {
  final GameCard suspect;
  final GameCard weapon;
  final GameCard room;
  final double benefit;

  Recommendation({
    required this.suspect,
    required this.weapon,
    required this.room,
    required this.benefit,
  });

  @override
  String toString() {
    return 'Recommendation(suspect: ${suspect.name}, weapon: ${weapon.name}, room: ${room.name}, benefit: $benefit)';
  }
}
