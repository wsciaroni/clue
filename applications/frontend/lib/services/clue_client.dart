import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import '../generated/clue.pbgrpc.dart' as proto;
import '../models/game_constants.dart'
    as model; // To avoid conflict with generated Card
import '../models/recommendation.dart';
import '../state/game_state.dart' as state;

class ClueClient {
  late proto.ClueGameServiceClient _stub;
  late ClientChannel _channel;
  String? _gameId;
  List<String> _playerNames = [];
  // Keep track of initialization to allow shutdown on re-connect
  bool _isInitialized = false;

  ClueClient() {
    // Default connection
    connect();
  }

  /// Connects to the backend service.
  /// If host/port are not provided, defaults to localhost:50051 (or 10.0.2.2 for Android).
  void connect({String? host, int? port}) {
    if (_isInitialized) {
      _channel.shutdown();
    }

    String finalHost = host ?? 'localhost';
    if (host == null && !kIsWeb && Platform.isAndroid) {
      finalHost = '10.0.2.2';
    }
    int finalPort = port ?? 50051;

    debugPrint('Connecting to Clue Backend at $finalHost:$finalPort');

    _channel = ClientChannel(
      finalHost,
      port: finalPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _stub = proto.ClueGameServiceClient(_channel);
    _isInitialized = true;
  }

  Future<void> initializeGame(
    List<String> players,
    List<model.GameCard> userHand, {
    List<int>? cardCounts,
  }) async {
    _playerNames = List.from(players);
    final request = proto.InitGameRequest()..numPlayers = players.length;

    request.playerNames.addAll(players);
    if (cardCounts != null) {
      request.playerCardCounts.addAll(cardCounts);
    }

    // Convert model.GameCard to generated Card
    for (var card in userHand) {
      request.myHand.add(_convertToProtoCard(card));
    }

    try {
      final response = await _stub.initGame(request);
      if (response.success) {
        _gameId = response.gameId;
        debugPrint('Game initialized with ID: $_gameId');
      } else {
        throw Exception('Failed to initialize game: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('Error initializing game: $e');
      rethrow;
    }
  }

  Future<void> submitTurn(state.GameTurn turn) async {
    if (_gameId == null) {
      debugPrint('Game ID is null, cannot submit a turn.');
      throw Exception(
        'Failed to record turn: Game ID is null, cannot submit a turn.',
      );
    }

    final turnData = _mapTurnData(turn);

    final request = proto.TurnRequest()
      ..gameId = _gameId!
      ..data = turnData;

    try {
      final response = await _stub.recordTurn(request);
      if (!response.success) {
        throw Exception('Failed to record turn: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('Error recording turn: $e');
      rethrow;
    }
  }

  Future<void> updateTurn(String turnId, state.GameTurn turn) async {
    if (_gameId == null) throw Exception("Game ID null");

    final turnData = _mapTurnData(turn);
    final request = proto.UpdateTurnRequest()
      ..gameId = _gameId!
      ..turnId = turnId
      ..newData = turnData;

    try {
      final response = await _stub.updateTurn(request);
      if (!response.success) {
        throw Exception('Failed to update turn: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('Error updating turn: $e');
      rethrow;
    }
  }

  Future<void> deleteTurn(String turnId) async {
    if (_gameId == null) throw Exception("Game ID null");

    final request = proto.DeleteTurnRequest()
      ..gameId = _gameId!
      ..turnId = turnId;

    try {
      final response = await _stub.deleteTurn(request);
      if (!response.success) {
        throw Exception('Failed to delete turn: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('Error deleting turn: $e');
      rethrow;
    }
  }

  Future<List<proto.TurnEntry>> getTurnHistory() async {
    if (_gameId == null) return [];
    final request = proto.GetHistoryRequest()..gameId = _gameId!;

    try {
      final response = await _stub.getTurnHistory(request);
      return response.history;
    } catch (e) {
      debugPrint('Error fetching history: $e');
      return [];
    }
  }

  Future<proto.GameStateResponse> fetchGameState() async {
    if (_gameId == null) {
      debugPrint('Game ID is null, cannot fetch game state.');
      return proto.GameStateResponse(); // Return empty
    }
    final request = proto.GameStateRequest()..gameId = _gameId!;

    try {
      return await _stub.getGameState(request);
    } catch (e) {
      debugPrint('Error fetching game state: $e');
      rethrow;
    }
  }

  Future<List<Recommendation>> getSuggestions({String? roomName}) async {
    if (_gameId == null) return [];
    final request = proto.GetNextMovesRequest()..gameId = _gameId!;
    if (roomName != null) {
      request.room = _mapRoom(roomName);
    }

    try {
      final response = await _stub.getNextMoves(request);
      return response.recommendations
          .map((r) => _mapProtoRecommendation(r))
          .whereType<Recommendation>()
          .toList();
    } catch (e) {
      debugPrint('Error fetching suggestions: $e');
      return [];
    }
  }

  Future<Recommendation?> getAccusationRecommendation() async {
    if (_gameId == null) return null;
    final request = proto.GetAccusationRecommendationRequest()..gameId = _gameId!;

    try {
      final response = await _stub.getAccusationRecommendation(request);
      return _mapProtoRecommendation(response.recommendation);
    } catch (e) {
      debugPrint('Error fetching accusation recommendation: $e');
      return null;
    }
  }

  Recommendation? _mapProtoRecommendation(
    proto.Recommendation recommendation,
  ) {
    final suspect = _protoToGameCard(recommendation.suspect);
    final weapon = _protoToGameCard(recommendation.weapon);
    final room = _protoToGameCard(recommendation.room);

    if (suspect != null && weapon != null && room != null) {
      return Recommendation(
        suspect: suspect,
        weapon: weapon,
        room: room,
        benefit: recommendation.benefit.toDouble(),
      );
    }
    return null;
  }

  model.GameCard? _protoToGameCard(proto.Card card) {
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
        return model.GameConstants.allCards.firstWhere(
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

  proto.TurnData _mapTurnData(state.GameTurn turn) {
    final turnData = proto.TurnData()
      ..suggesterPlayerIndex = _getPlayerIndex(turn.askingPlayer.name)
      ..suspect = _convertToProtoCard(turn.suspect)
      ..weapon = _convertToProtoCard(turn.weapon)
      ..room = _convertToProtoCard(turn.room);

    if (turn.answeringPlayer == null) {
      turnData.responderPlayerIndex = -1;
    } else {
      turnData.responderPlayerIndex = _getPlayerIndex(turn.answeringPlayer!.name);
    }

    if (turn.specificCardShown != null) {
      turnData.cardShown = _convertToProtoCard(turn.specificCardShown!);
    }

    turnData.isAccusation = turn.isAccusation;
    turnData.wasCorrect = turn.wasCorrect;
    return turnData;
  }

  // Helper to find index
  int _getPlayerIndex(String name) {
    int index = _playerNames.indexOf(name);
    if (index == -1) {
      debugPrint("Error: Player $name not found in local list $_playerNames");
      throw StateError("Player $name not found in local list $_playerNames");
    }
    return index;
  }

  Future<void> shutdown() async {
    if (_isInitialized) {
      await _channel.shutdown();
    }
  }

  proto.Card _convertToProtoCard(model.GameCard card) {
    final protoCard = proto.Card();

    if (card.type == model.CardType.suspect) {
      protoCard.type = proto.CardType.CARD_TYPE_SUSPECT;
      protoCard.suspect = _mapSuspect(card.name);
    } else if (card.type == model.CardType.weapon) {
      protoCard.type = proto.CardType.CARD_TYPE_WEAPON;
      protoCard.weapon = _mapWeapon(card.name);
    } else if (card.type == model.CardType.room) {
      protoCard.type = proto.CardType.CARD_TYPE_ROOM;
      protoCard.room = _mapRoom(card.name);
    }

    return protoCard;
  }

  proto.Suspect _mapSuspect(String name) {
    switch (name) {
      case 'Colonel Mustard':
        return proto.Suspect.SUSPECT_COL_MUSTARD;
      case 'Professor Plum':
        return proto.Suspect.SUSPECT_PROF_PLUM;
      case 'Mr. Green':
        return proto.Suspect.SUSPECT_MR_GREEN;
      case 'Mrs. Peacock':
        return proto.Suspect.SUSPECT_MRS_PEACOCK;
      case 'Miss Scarlet':
        return proto.Suspect.SUSPECT_MISS_SCARLET;
      case 'Mrs. White':
        return proto.Suspect.SUSPECT_MRS_WHITE;
      default:
        return proto.Suspect.SUSPECT_UNKNOWN;
    }
  }

  proto.Weapon _mapWeapon(String name) {
    switch (name) {
      case 'Knife':
        return proto.Weapon.WEAPON_KNIFE;
      case 'Candlestick':
        return proto.Weapon.WEAPON_CANDLESTICK;
      case 'Revolver':
        return proto.Weapon.WEAPON_REVOLVER;
      case 'Rope':
        return proto.Weapon.WEAPON_ROPE;
      case 'Lead Pipe':
        return proto.Weapon.WEAPON_LEAD_PIPE;
      case 'Wrench':
        return proto.Weapon.WEAPON_WRENCH;
      default:
        return proto.Weapon.WEAPON_UNKNOWN;
    }
  }

  proto.Room _mapRoom(String name) {
    switch (name) {
      case 'Hall':
        return proto.Room.ROOM_HALL;
      case 'Lounge':
        return proto.Room.ROOM_LOUNGE;
      case 'Dining Room':
        return proto.Room.ROOM_DINING_ROOM;
      case 'Kitchen':
        return proto.Room.ROOM_KITCHEN;
      case 'Ballroom':
        return proto.Room.ROOM_BALLROOM;
      case 'Conservatory':
        return proto.Room.ROOM_CONSERVATORY;
      case 'Billiard Room':
        return proto.Room.ROOM_BILLIARD_ROOM;
      case 'Library':
        return proto.Room.ROOM_LIBRARY;
      case 'Study':
        return proto.Room.ROOM_STUDY;
      default:
        return proto.Room.ROOM_UNKNOWN;
    }
  }
}
