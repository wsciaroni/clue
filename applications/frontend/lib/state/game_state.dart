import 'package:flutter/foundation.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../models/solution_probability.dart';
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
    this.answeringPlayer,
    required this.cardShown,
    this.specificCardShown,
  });

  @override
  String toString() {
    String base =
        '${askingPlayer.name} asked ${answeringPlayer?.name ?? "No one"} about $suspect, $weapon, $room.';
    if (answeringPlayer != null) {
      if (specificCardShown != null) {
        return '$base Shown: $specificCardShown.';
      } else {
        return '$base Card shown (hidden).';
      }
    } else {
      return '$base No one answered.';
    }
  }
}

class GameState extends ChangeNotifier {
  final ClueClient _client;
  List<Player> _players = [];

  GameState({ClueClient? client}) : _client = client ?? ClueClient();
  final List<GameTurn> _turnLog = [];
  List<LocalSolutionProbability> _solutionProbabilities = [];
  bool _gameStarted = false;
  List<GameCard> _userHand = [];

  List<Player> get players => _players;
  List<GameTurn> get turnLog => _turnLog;
  List<LocalSolutionProbability> get solutionProbabilities => _solutionProbabilities;
  bool get gameStarted => _gameStarted;

  Future<void> startGame(
    List<String> playerNames,
    List<GameCard> userHand,
  ) async {
    _players = playerNames.map((name) => Player(name: name)).toList();
    _userHand = List.from(userHand);

    // Apply initial hand knowledge
    _applyUserHand();

    try {
      await _client.initializeGame(playerNames, userHand);
      final gameStateResponse = await _client.fetchGameState();
      _updateDeductions(gameStateResponse);
    } catch (e) {
      debugPrint('Failed to initialize game on backend: $e');
    }

    _gameStarted = true;
    notifyListeners();
  }

  Future<void> recordTurn(GameTurn turn) async {
    _turnLog.insert(0, turn); // Add to top of list
    _applyTurnDeductions(turn);
    notifyListeners();

    try {
      await _client.submitTurn(turn);
      final gameStateResponse = await _client.fetchGameState();
      _updateDeductions(gameStateResponse);
    } catch (e) {
      debugPrint('Failed to sync turn or fetch deductions: $e');
    }
  }

  Future<void> updateTurn(int index, GameTurn newTurn) async {
    if (index < 0 || index >= _turnLog.length) return;

    // Optimistic update locally first
    _turnLog[index] = newTurn;
    _recalculateState();

    try {
      // We need the Turn ID to update it on the backend.
      // Since we don't store IDs locally in GameTurn (yet), we fetch history.
      // The history is ordered. Assuming order consistency.
      final history = await _client.fetchTurnHistory();

      // Map index (local 0 is newest) to history (0 is oldest usually? or matches?)
      // GetHistoryResponse returns repeated TurnEntry history.
      // Usually append-only logs are returned in insertion order (oldest first).
      // _turnLog is newest first (0 is newest).
      // So _turnLog[index] corresponds to history[history.length - 1 - index].

      if (history.length != _turnLog.length) {
         debugPrint("Warning: Local turn log length mismatch with server history.");
         // Fallback? If we can't match, we can't safely update.
         return;
      }

      final historyIndex = history.length - 1 - index;
      if (historyIndex >= 0 && historyIndex < history.length) {
        final turnId = history[historyIndex].turnId;
        await _client.updateTurn(turnId, newTurn);

        // Fetch fresh state (probabilities etc)
        final gameStateResponse = await _client.fetchGameState();
        _updateDeductions(gameStateResponse);
      }
    } catch (e) {
      debugPrint('Failed to sync updated turn: $e');
      // Ideally rollback? But for now just log.
    }
  }

  void _recalculateState() {
    // Reset status to unknown
    for (var p in _players) {
      p.cardStatus.clear();
    }

    // Re-apply initial hand knowledge
    _applyUserHand();

    // Re-applying turns in REVERSE order (oldest first)
    // Note: _turnLog has newest at index 0. So we iterate end to start.
    for (var i = _turnLog.length - 1; i >= 0; i--) {
      _applyTurnDeductions(_turnLog[i]);
    }

    notifyListeners();
  }

  void _applyUserHand() {
    // Logic: If the user enters their hand, we find the "User" player (assuming first one or matching name)
    // and mark those cards as 'hasIt'.
    // For this implementation, let's assume the first player in the list is the user.
    if (_players.isNotEmpty) {
      for (var card in _userHand) {
        _players.first.setStatus(card, DeductionStatus.hasIt);
        // Consequently, all other players do NOT have this card (if it's unique, which standard Clue cards are)
        for (var i = 1; i < _players.length; i++) {
          _players[i].setStatus(card, DeductionStatus.doesNotHaveIt);
        }
      }
    }
  }

  void _applyTurnDeductions(GameTurn turn) {
    // Basic Deduction Logic (Client-side immediate feedback)
    if (turn.answeringPlayer == null) {
       // If No one answered, then everyone (except the asker) does NOT have any of the three cards.
       for (var p in _players) {
         if (p != turn.askingPlayer) {
           p.setStatus(turn.suspect, DeductionStatus.doesNotHaveIt);
           p.setStatus(turn.weapon, DeductionStatus.doesNotHaveIt);
           p.setStatus(turn.room, DeductionStatus.doesNotHaveIt);
         }
       }
    } else {
      // Answering player showed a card. They have AT LEAST one of them.
      // If specific card is known:
      if (turn.specificCardShown != null) {
        turn.answeringPlayer!.setStatus(
          turn.specificCardShown!,
          DeductionStatus.hasIt,
        );
        // Other players do not have it
        for (var p in _players) {
          if (p != turn.answeringPlayer!) {
            p.setStatus(turn.specificCardShown!, DeductionStatus.doesNotHaveIt);
          }
        }
      }
    }
  }

  void _updateDeductions(proto.GameStateResponse response) {
    // GameStateResponse has rows. Each row has a card and player states.
    for (var row in response.rows) {
      // Find the GameCard for this row
      // Map proto card back to GameCard.
      // Try by type and enum value.
      GameCard? gameCard = _protoToGameCard(row.card);

      if (gameCard == null) continue;

      // Iterate over players
      // player_states is a list, indices match players order in InitGame
      for (int i = 0; i < row.playerStates.length; i++) {
        if (i >= _players.length) break;

        var protoState = row.playerStates[i].status;
        var localStatus = _mapProtoStatus(protoState);

        if (localStatus != null) {
          _players[i].setStatus(gameCard, localStatus);
        }
      }
    }

    // Process Solution Probabilities
    _solutionProbabilities = [];
    for (var sp in response.solutionProbabilities) {
      GameCard? gameCard = _protoToGameCard(sp.card);
      if (gameCard != null) {
        _solutionProbabilities.add(LocalSolutionProbability(
          card: gameCard,
          probability: sp.probability,
          isEliminated: sp.isEliminated,
        ));
      }
    }

    notifyListeners();
  }

  GameCard? _protoToGameCard(proto.Card card) {
      String? targetName;
      if (card.type == proto.CardType.CARD_TYPE_SUSPECT) {
        targetName = _mapSuspectToName(card.suspect);
      } else if (card.type == proto.CardType.CARD_TYPE_WEAPON) {
        targetName = _mapWeaponToName(card.weapon);
      } else if (card.type == proto.CardType.CARD_TYPE_ROOM) {
        targetName = _mapRoomToName(card.room);
      }

      if (targetName != null) {
        try {
          return GameConstants.allCards.firstWhere(
            (c) => c.name == targetName,
          );
        } catch (_) {
          return null;
        }
      }
      return null;
  }

  String? _mapSuspectToName(proto.Suspect s) {
    switch (s) {
      case proto.Suspect.SUSPECT_COL_MUSTARD:
        return 'Colonel Mustard';
      case proto.Suspect.SUSPECT_PROF_PLUM:
        return 'Professor Plum';
      case proto.Suspect.SUSPECT_MR_GREEN:
        return 'Mr. Green';
      case proto.Suspect.SUSPECT_MRS_PEACOCK:
        return 'Mrs. Peacock';
      case proto.Suspect.SUSPECT_MISS_SCARLET:
        return 'Miss Scarlet';
      case proto.Suspect.SUSPECT_MRS_WHITE:
        return 'Mrs. White';
      default:
        return null;
    }
  }

  String? _mapWeaponToName(proto.Weapon w) {
    switch (w) {
      case proto.Weapon.WEAPON_KNIFE:
        return 'Knife';
      case proto.Weapon.WEAPON_CANDLESTICK:
        return 'Candlestick';
      case proto.Weapon.WEAPON_REVOLVER:
        return 'Revolver';
      case proto.Weapon.WEAPON_ROPE:
        return 'Rope';
      case proto.Weapon.WEAPON_LEAD_PIPE:
        return 'Lead Pipe';
      case proto.Weapon.WEAPON_WRENCH:
        return 'Wrench';
      default:
        return null;
    }
  }

  String? _mapRoomToName(proto.Room r) {
    switch (r) {
      case proto.Room.ROOM_HALL:
        return 'Hall';
      case proto.Room.ROOM_LOUNGE:
        return 'Lounge';
      case proto.Room.ROOM_DINING_ROOM:
        return 'Dining Room';
      case proto.Room.ROOM_KITCHEN:
        return 'Kitchen';
      case proto.Room.ROOM_BALLROOM:
        return 'Ballroom';
      case proto.Room.ROOM_CONSERVATORY:
        return 'Conservatory';
      case proto.Room.ROOM_BILLIARD_ROOM:
        return 'Billiard Room';
      case proto.Room.ROOM_LIBRARY:
        return 'Library';
      case proto.Room.ROOM_STUDY:
        return 'Study';
      default:
        return null;
    }
  }

  // CardType _mapProtoCardType(proto.CardType type) {
  //   switch (type) {
  //     case proto.CardType.CARD_TYPE_SUSPECT: return CardType.suspect;
  //     case proto.CardType.CARD_TYPE_WEAPON: return CardType.weapon;
  //     case proto.CardType.CARD_TYPE_ROOM: return CardType.room;
  //     default: return CardType.suspect; // Fallback
  //   }
  // }

  DeductionStatus? _mapProtoStatus(proto.CellState_Status status) {
    switch (status) {
      case proto.CellState_Status.HAS:
        return DeductionStatus.hasIt;
      case proto.CellState_Status.DOES_NOT_HAVE:
        return DeductionStatus.doesNotHaveIt;
      case proto.CellState_Status.MIGHT_HAVE:
        return DeductionStatus.mightHaveIt;
      case proto.CellState_Status.UNKNOWN:
        return DeductionStatus.unknown;
      default:
        return null;
    }
  }

  void reset() {
    _players = [];
    _turnLog.clear();
    _solutionProbabilities = [];
    _gameStarted = false;
    notifyListeners();
  }
}
