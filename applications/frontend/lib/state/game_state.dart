import 'package:flutter/foundation.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../services/clue_client.dart';
import '../generated/clue.pb.dart' as proto;

class GameTurn {
  final Player askingPlayer;
  final GameCard suspect;
  final GameCard weapon;
  final GameCard room;
  final Player? answeringPlayer;
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
    String responderName = answeringPlayer?.name ?? "No One";
    String base = '${askingPlayer.name} asked $responderName about $suspect, $weapon, $room.';
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
  final ClueClient _client = ClueClient();
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

  Future<void> startGame(List<String> playerNames, List<GameCard> userHand) async {
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

    try {
      await _client.initializeGame(playerNames, userHand);
    } catch (e) {
      debugPrint('Failed to initialize game on backend: $e');
    }

    _gameStarted = true;
    notifyListeners();
  }

  Future<void> recordTurn(GameTurn turn) async {
    _turnLog.insert(0, turn); // Add to top of list

    // Basic Deduction Logic (Client-side immediate feedback)
    if (turn.answeringPlayer == null) {
      // If No One answered, it means NO ONE (except possibly asker) has the cards.
      // Iterate over all players except the asker.
      for (var p in _players) {
        if (p != turn.askingPlayer) {
          p.setStatus(turn.suspect, DeductionStatus.doesNotHaveIt);
          p.setStatus(turn.weapon, DeductionStatus.doesNotHaveIt);
          p.setStatus(turn.room, DeductionStatus.doesNotHaveIt);
        }
      }
    } else {
      if (!turn.cardShown) {
        // If answering player did NOT show a card, they do not have ANY of the three.
        turn.answeringPlayer!.setStatus(turn.suspect, DeductionStatus.doesNotHaveIt);
        turn.answeringPlayer!.setStatus(turn.weapon, DeductionStatus.doesNotHaveIt);
        turn.answeringPlayer!.setStatus(turn.room, DeductionStatus.doesNotHaveIt);
      } else {
        // Answering player showed a card. They have AT LEAST one of them.
        // If specific card is known:
        if (turn.specificCardShown != null) {
          turn.answeringPlayer!.setStatus(turn.specificCardShown!, DeductionStatus.hasIt);
          // Other players do not have it
          for (var p in _players) {
            if (p != turn.answeringPlayer) {
               p.setStatus(turn.specificCardShown!, DeductionStatus.doesNotHaveIt);
            }
          }
        }
      }
    }
    notifyListeners();

    try {
      await _client.submitTurn(turn);
      final deductionResponse = await _client.fetchDeductions();
      _updateDeductions(deductionResponse);
    } catch (e) {
       debugPrint('Failed to sync turn or fetch deductions: $e');
    }
  }

  void _updateDeductions(proto.DeductionResponse response) {
    for (var knowledge in response.knowledge) {
       // Find player
       try {
         final player = _players.firstWhere((p) => p.name == knowledge.playerName);
         // Find card
         // We need to map proto card back to GameCard.
         // Since we don't have an easy ID map, we'll try by name.
         final gameCard = GameConstants.allCards.firstWhere(
           (c) => c.name == knowledge.card.name,
           orElse: () => GameCard(knowledge.card.name, _mapProtoCardType(knowledge.card.type))
         );

         final status = _mapProtoStatus(knowledge.status);
         if (status != null) {
            player.setStatus(gameCard, status);
         }

       } catch (e) {
         debugPrint('Error updating deduction for ${knowledge.playerName}: $e');
       }
    }
    notifyListeners();
  }

  CardType _mapProtoCardType(proto.CardType type) {
    switch (type) {
      case proto.CardType.CARD_TYPE_SUSPECT: return CardType.suspect;
      case proto.CardType.CARD_TYPE_WEAPON: return CardType.weapon;
      case proto.CardType.CARD_TYPE_ROOM: return CardType.room;
      default: return CardType.suspect; // Fallback
    }
  }

  DeductionStatus? _mapProtoStatus(proto.DeductionStatus status) {
    switch (status) {
      case proto.DeductionStatus.HAS_IT: return DeductionStatus.hasIt;
      case proto.DeductionStatus.DOES_NOT_HAVE_IT: return DeductionStatus.doesNotHaveIt;
      case proto.DeductionStatus.MIGHT_HAVE_IT: return DeductionStatus.mightHaveIt; // Make sure mightHaveIt exists in local enum or map appropriately
      default: return null;
    }
  }

  void reset() {
    _players = [];
    _turnLog.clear();
    _gameStarted = false;
    notifyListeners();
  }
}
