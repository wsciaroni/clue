import 'game_constants.dart';

enum DeductionStatus {
  unknown,
  hasIt, // Green Check
  doesNotHaveIt, // Red X
  mightHaveIt, // Question mark
}

class Player {
  final String name;
  final int cardCount;
  final Map<GameCard, DeductionStatus> cardStatus;

  Player({required this.name, this.cardCount = 0}) : cardStatus = {};

  void setStatus(GameCard card, DeductionStatus status) {
    cardStatus[card] = status;
  }

  DeductionStatus getStatus(GameCard card) {
    return cardStatus[card] ?? DeductionStatus.unknown;
  }
}
