import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../models/solution_probability.dart';
import '../models/recommendation.dart';
import '../services/clue_client.dart';
import '../generated/clue.pb.dart' as proto;

enum BackendStatus {
  connected,
  disconnected,
  restoring,
}

class GameTurn {
  final String? id; // Sync with backend ID
  final Player askingPlayer;
  final GameCard suspect;
  final GameCard weapon;
  final GameCard room;
  final Player? answeringPlayer;
  final GameCard? specificCardShown; // Optional, if user saw it
  final bool isAccusation;
  final bool wasCorrect;

  GameTurn({
    this.id,
    required this.askingPlayer,
    required this.suspect,
    required this.weapon,
    required this.room,
    this.answeringPlayer,
    this.specificCardShown,
    this.isAccusation = false,
    this.wasCorrect = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'askingPlayer': askingPlayer.name,
      'suspect': suspect.name,
      'weapon': weapon.name,
      'room': room.name,
      'answeringPlayer': answeringPlayer?.name,
      'specificCardShown': specificCardShown?.name,
      'isAccusation': isAccusation,
      'wasCorrect': wasCorrect,
    };
  }

  static GameTurn? fromJson(Map<String, dynamic> json, List<Player> players) {
    try {
      final askingName = json['askingPlayer'] as String;
      final asking = players.firstWhere((p) => p.name == askingName);

      final suspect = GameConstants.getCardByName(json['suspect'] as String);
      final weapon = GameConstants.getCardByName(json['weapon'] as String);
      final room = GameConstants.getCardByName(json['room'] as String);

      if (suspect == null || weapon == null || room == null) return null;

      Player? answering;
      if (json['answeringPlayer'] != null) {
        final answeringName = json['answeringPlayer'] as String;
        try {
          answering = players.firstWhere((p) => p.name == answeringName);
        } catch (_) {}
      }

      GameCard? shown;
      if (json['specificCardShown'] != null) {
        shown = GameConstants.getCardByName(json['specificCardShown'] as String);
      }

      return GameTurn(
        askingPlayer: asking,
        suspect: suspect,
        weapon: weapon,
        room: room,
        answeringPlayer: answering,
        specificCardShown: shown,
        isAccusation: json['isAccusation'] ?? false,
        wasCorrect: json['wasCorrect'] ?? false,
      );
    } catch (e) {
      debugPrint('Error deserializing turn: $e');
      return null;
    }
  }

  @override
  String toString() {
    if (isAccusation) {
       return '${askingPlayer.name} made an ACCUSATION: $suspect, $weapon, $room. Result: ${wasCorrect ? "Correct" : "Incorrect"}.';
    }

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
  List<GameCard> _userHand = [];

  GameState({ClueClient? client}) : _client = client ?? ClueClient();
  List<GameTurn> _turnLog = [];
  List<LocalSolutionProbability> _solutionProbabilities = [];
  bool _gameStarted = false;

  // Connection Management
  BackendStatus _connectionStatus = BackendStatus.disconnected;
  Timer? _heartbeatTimer;

  List<Player> get players => _players;
  List<GameTurn> get turnLog => _turnLog;
  List<LocalSolutionProbability> get solutionProbabilities => _solutionProbabilities;
  bool get gameStarted => _gameStarted;
  BackendStatus get connectionStatus => _connectionStatus;

  void updateConnectionSettings(String? host, int? port) {
    _client.connect(host: host, port: port);
    // Restart heartbeat on new connection settings
    _startHeartbeat();
  }

  void _startHeartbeat({bool checkImmediately = true}) {
    _heartbeatTimer?.cancel();
    // Check immediately
    if (checkImmediately) {
      _checkConnection();
    }
    // Then every 20 seconds
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      _checkConnection();
    });
  }

  @visibleForTesting
  Future<void> checkConnectionForTesting() => _checkConnection();

  Future<void> _checkConnection() async {
    if (!_gameStarted) {
      // If game hasn't started, we might just want to ping?
      // Or we can assume we are "Disconnected" until we try to start?
      // For now, let's only check if game started to keep it simple,
      // or we can implement a specific Ping RPC.
      // Since we don't have a game ID, fetchGameState() would return empty.
      // We will skip checks if game hasn't started.
      return;
    }

    // Don't check if we are in the middle of restoring
    if (_connectionStatus == BackendStatus.restoring) return;

    try {
      final response = await _client.fetchGameState();

      // If response is valid and has players/gameId, we are good.
      // Note: GetGameState returns default object if not found.
      // A valid game state should have players or a game ID.
      // If game_id is empty, it means game not found.
      if (response.gameId.isEmpty) {
        debugPrint("Heartbeat: Connected but Game Not Found. Restoring...");
        _updateStatus(BackendStatus.restoring);
        await _restoreGameSession();
      } else {
        _updateStatus(BackendStatus.connected);
      }
    } catch (e) {
      debugPrint("Heartbeat: Connection failed: $e");
      _updateStatus(BackendStatus.disconnected);
    }
  }

  void _updateStatus(BackendStatus newStatus) {
    if (_connectionStatus != newStatus) {
      _connectionStatus = newStatus;
      notifyListeners();
    }
  }

  Future<void> _restoreGameSession() async {
    try {
      final playerNames = _players.map((p) => p.name).toList();
      final cardCounts = _players.map((p) => p.cardCount).toList();

      debugPrint("Restoring Game Session for ${playerNames.length} players...");

      // 1. Re-initialize Game
      await _client.initializeGame(playerNames, _userHand, cardCounts: cardCounts);

      // 2. Replay Turns (Chronological Order)
      // _turnLog is stored in reverse chronological order (newest first).
      // We need to reverse it to submit in order.
      final turnsToReplay = _turnLog.reversed.toList();

      for (var turn in turnsToReplay) {
         await _client.submitTurn(turn);
      }

      // 3. Sync Final State
      final gameStateResponse = await _client.fetchGameState();
      _updateDeductions(gameStateResponse);

      debugPrint("Game Session Restored Successfully.");
      _updateStatus(BackendStatus.connected);
    } catch (e) {
      debugPrint("Failed to restore game session: $e");
      // Stay in restoring or go to disconnected?
      // If init failed, we are likely disconnected or backend error.
      _updateStatus(BackendStatus.disconnected);
    }
  }

  Future<List<Recommendation>> getSuggestions({String? roomName}) async {
    return _client.getSuggestions(roomName: roomName);
  }

  Future<Recommendation?> getAccusationRecommendation() async {
    return _client.getAccusationRecommendation();
  }

  Future<void> startGame(
    List<String> playerNames,
    List<GameCard> userHand, {
    List<int>? cardCounts,
  }) async {
    _userHand = userHand;
    _players = [];
    for (int i = 0; i < playerNames.length; i++) {
      int count = (cardCounts != null && i < cardCounts.length) ? cardCounts[i] : 0;
      _players.add(Player(name: playerNames[i], cardCount: count));
    }

    // Logic: If the user enters their hand, we find the "User" player (assuming first one or matching name)
    // and mark those cards as 'hasIt'.
    if (_players.isNotEmpty) {
      for (var card in userHand) {
        _players.first.setStatus(card, DeductionStatus.hasIt);
        // Consequently, all other players do NOT have this card
        for (var i = 1; i < _players.length; i++) {
          _players[i].setStatus(card, DeductionStatus.doesNotHaveIt);
        }
      }
    }

    try {
      await _client.initializeGame(playerNames, userHand, cardCounts: cardCounts);
      final gameStateResponse = await _client.fetchGameState();
      _updateDeductions(gameStateResponse);
      _updateStatus(BackendStatus.connected); // Success
    } catch (e) {
      debugPrint('Failed to initialize game on backend: $e');
      _updateStatus(BackendStatus.disconnected);
    }

    _gameStarted = true;
    _startHeartbeat(checkImmediately: false); // Start monitoring
    notifyListeners();
  }

  String toJson() {
    final data = {
      'players': _players
          .map((p) => {'name': p.name, 'cardCount': p.cardCount})
          .toList(),
      'userHand': _userHand.map((c) => c.name).toList(),
      'turns': _turnLog.reversed.map((t) => t.toJson()).toList(), // Save in chronological order
    };
    return jsonEncode(data);
  }

  Future<void> loadGame(String jsonString) async {
    try {
      final data = jsonDecode(jsonString);
      final playersData = (data['players'] as List).cast<Map<String, dynamic>>();
      final handData = (data['userHand'] as List).cast<String>();
      final turnData = (data['turns'] as List).cast<Map<String, dynamic>>();

      final playerNames = playersData.map((p) => p['name'] as String).toList();
      final cardCounts = playersData.map((p) => p['cardCount'] as int).toList();

      final userHand = handData
          .map((name) => GameConstants.getCardByName(name))
          .whereType<GameCard>()
          .toList();

      // Initialize Game
      await startGame(playerNames, userHand, cardCounts: cardCounts);

      // Replay Turns
      // We must replay them one by one.
      for (var tJson in turnData) {
        final turn = GameTurn.fromJson(tJson, _players);
        if (turn != null) {
          // Use recordTurn but wait for it.
          // Note: recordTurn puts it at index 0 of _turnLog (reversed order for UI),
          // but we are reading them chronologically.
          await recordTurn(turn);
        }
      }

    } catch (e) {
      debugPrint("Failed to load game: $e");
      rethrow;
    }
  }

  Future<void> recordTurn(GameTurn turn) async {
    // Optimistic Update
    _turnLog.insert(0, turn);
    notifyListeners();

    try {
      await _client.submitTurn(turn);
      await _syncTurnHistory();
      final gameStateResponse = await _client.fetchGameState();
      _updateDeductions(gameStateResponse);
      _updateStatus(BackendStatus.connected);
    } catch (e) {
      debugPrint('Failed to sync turn or fetch deductions: $e');
      _updateStatus(BackendStatus.disconnected);
      // Revert optimism if needed? Or just show error.
    }
  }

  Future<void> updateTurn(GameTurn turn) async {
    if (turn.id == null) {
      debugPrint("Cannot update turn without ID");
      return;
    }

    try {
      await _client.updateTurn(turn.id!, turn);
      await _syncTurnHistory();
      final gameStateResponse = await _client.fetchGameState();
      _updateDeductions(gameStateResponse);
      _updateStatus(BackendStatus.connected);
    } catch (e) {
      debugPrint('Failed to update turn: $e');
      _updateStatus(BackendStatus.disconnected);
    }
  }

  Future<void> deleteTurn(GameTurn turn) async {
     if (turn.id == null) {
      debugPrint("Cannot delete turn without ID");
      return;
    }

    try {
      await _client.deleteTurn(turn.id!);
      await _syncTurnHistory();
      final gameStateResponse = await _client.fetchGameState();
      _updateDeductions(gameStateResponse);
      _updateStatus(BackendStatus.connected);
    } catch (e) {
       debugPrint('Failed to delete turn: $e');
       _updateStatus(BackendStatus.disconnected);
    }
  }

  Future<void> _syncTurnHistory() async {
    try {
      final history = await _client.getTurnHistory();
      _turnLog = history.reversed.map((entry) => _protoToGameTurn(entry)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to sync history: $e');
      // If this fails, connection is suspect
      rethrow; // Let the caller handle connection status update
    }
  }

  GameTurn _protoToGameTurn(proto.TurnEntry entry) {
    final data = entry.data;

    // Find players
    Player asking = _players.length > data.suggesterPlayerIndex
      ? _players[data.suggesterPlayerIndex]
      : Player(name: "Unknown");

    Player? answering;
    if (data.responderPlayerIndex != -1 && _players.length > data.responderPlayerIndex) {
      answering = _players[data.responderPlayerIndex];
    }

    GameCard suspect = _protoToGameCard(data.suspect) ?? GameConstants.suspects.first;
    GameCard weapon = _protoToGameCard(data.weapon) ?? GameConstants.weapons.first;
    GameCard room = _protoToGameCard(data.room) ?? GameConstants.rooms.first;
    GameCard? shown = data.hasCardShown() ? _protoToGameCard(data.cardShown) : null;

    return GameTurn(
      id: entry.turnId,
      askingPlayer: asking,
      suspect: suspect,
      weapon: weapon,
      room: room,
      answeringPlayer: answering,
      specificCardShown: shown,
      isAccusation: data.isAccusation,
      wasCorrect: data.wasCorrect,
    );
  }

  void _updateDeductions(proto.GameStateResponse response) {
    // GameStateResponse has rows. Each row has a card and player states.
    for (var row in response.rows) {
      GameCard? gameCard = _protoToGameCard(row.card);

      if (gameCard == null) continue;

      // Iterate over players
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
    _heartbeatTimer?.cancel();
    _connectionStatus = BackendStatus.disconnected;
    notifyListeners();
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    super.dispose();
  }
}
