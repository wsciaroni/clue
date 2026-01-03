import 'package:flutter/foundation.dart';
import '../models/game_constants.dart';
import '../models/player.dart';

class GameTurn {
  final Player askingPlayer;
  final GameCard suspect;
  final GameCard weapon;
  final GameCard room;
  final Player answeringPlayer;
  final bool cardShown;
  final GameCard? specificCardShown; // Optional, if user saw it

  GameTurn({
    required this.askingPlayer,
    required this.suspect,
    required this.weapon,
    required this.room,
    required this.answeringPlayer,
    required this.cardShown,
    this.specificCardShown,
  });

  @override
  String toString() {
    String base = '${askingPlayer.name} asked ${answeringPlayer.name} about $suspect, $weapon, $room.';
    if (cardShown) {
      if (specificCardShown != null) {
        return '$base Shown: $specificCardShown.';
      } else {
        return '$base Card shown (hidden).';
      }
    } else {
      return '$base No card shown.';
    }
  }
}

class GameState extends ChangeNotifier {
  List<Player> _players = [];
  final List<GameTurn> _turnLog = [];
  bool _gameStarted = false;

  List<Player> get players => _players;
  List<GameTurn> get turnLog => _turnLog;
  bool get gameStarted => _gameStarted;

  // The "User" is assumed to be the first player for simplicity in this version,
  // or we can explicitly track which player object represents the user.
  // For now, let's assume the user enters themselves first or selects themselves.
  // We'll add a helper to identifying the main user if needed.

  void startGame(List<String> playerNames, List<GameCard> userHand) {
    _players = playerNames.map((name) => Player(name: name)).toList();

    // Logic: If the user enters their hand, we find the "User" player (assuming first one or matching name)
    // and mark those cards as 'hasIt'.
    // For this implementation, let's assume the first player in the list is the user.
    if (_players.isNotEmpty) {
       for (var card in userHand) {
         _players.first.setStatus(card, DeductionStatus.hasIt);
         // Consequently, all other players do NOT have this card (if it's unique, which standard Clue cards are)
         for (var i = 1; i < _players.length; i++) {
            _players[i].setStatus(card, DeductionStatus.doesNotHaveIt);
         }
       }
    }

    _gameStarted = true;
    notifyListeners();
  }

  void recordTurn(GameTurn turn) {
    _turnLog.insert(0, turn); // Add to top of list

    // Basic Deduction Logic
    if (!turn.cardShown) {
      // If answering player did NOT show a card, they do not have ANY of the three.
      turn.answeringPlayer.setStatus(turn.suspect, DeductionStatus.doesNotHaveIt);
      turn.answeringPlayer.setStatus(turn.weapon, DeductionStatus.doesNotHaveIt);
      turn.answeringPlayer.setStatus(turn.room, DeductionStatus.doesNotHaveIt);
    } else {
      // Answering player showed a card. They have AT LEAST one of them.
      // If specific card is known:
      if (turn.specificCardShown != null) {
        turn.answeringPlayer.setStatus(turn.specificCardShown!, DeductionStatus.hasIt);
        // Other players do not have it
        for (var p in _players) {
          if (p != turn.answeringPlayer) {
             p.setStatus(turn.specificCardShown!, DeductionStatus.doesNotHaveIt);
          }
        }
      }
    }

    notifyListeners();
  }

  void reset() {
    _players = [];
    _turnLog.clear();
    _gameStarted = false;
    notifyListeners();
  }
}
