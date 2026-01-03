enum CardType { suspect, weapon, room }

class GameCard {
  final String name;
  final CardType type;

  const GameCard(this.name, this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameCard &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => name.hashCode ^ type.hashCode;

  @override
  String toString() => name;
}

class GameConstants {
  static const List<GameCard> suspects = [
    GameCard('Colonel Mustard', CardType.suspect),
    GameCard('Miss Scarlet', CardType.suspect),
    GameCard('Professor Plum', CardType.suspect),
    GameCard('Mr. Green', CardType.suspect),
    GameCard('Mrs. White', CardType.suspect),
    GameCard('Mrs. Peacock', CardType.suspect),
  ];

  static const List<GameCard> weapons = [
    GameCard('Candlestick', CardType.weapon),
    GameCard('Knife', CardType.weapon),
    GameCard('Lead Pipe', CardType.weapon),
    GameCard('Revolver', CardType.weapon),
    GameCard('Rope', CardType.weapon),
    GameCard('Wrench', CardType.weapon),
  ];

  static const List<GameCard> rooms = [
    GameCard('Kitchen', CardType.room),
    GameCard('Ballroom', CardType.room),
    GameCard('Conservatory', CardType.room),
    GameCard('Dining Room', CardType.room),
    GameCard('Billiard Room', CardType.room),
    GameCard('Library', CardType.room),
    GameCard('Lounge', CardType.room),
    GameCard('Hall', CardType.room),
    GameCard('Study', CardType.room),
  ];

  static List<GameCard> get allCards => [...suspects, ...weapons, ...rooms];
}
