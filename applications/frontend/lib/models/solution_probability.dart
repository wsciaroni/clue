import '../models/game_constants.dart';

class LocalSolutionProbability {
  final GameCard card;
  final double probability;
  final bool isEliminated;

  LocalSolutionProbability({
    required this.card,
    required this.probability,
    required this.isEliminated,
  });

  @override
  String toString() {
    return '${card.name}: ${(probability * 100).toStringAsFixed(1)}%';
  }
}
