import 'game_constants.dart';

enum DeductionStatus {
  unknown,
  hasIt, // Green Check
  doesNotHaveIt, // Red X
}

class Player {
  final String name;
  final Map<GameCard, DeductionStatus> cardStatus;

  Player({required this.name}) : cardStatus = {};

  void setStatus(GameCard card, DeductionStatus status) {
    cardStatus[card] = status;
  }

  DeductionStatus getStatus(GameCard card) {
    return cardStatus[card] ?? DeductionStatus.unknown;
  }
}
