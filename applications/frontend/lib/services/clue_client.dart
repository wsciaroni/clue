import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import '../generated/clue.pbgrpc.dart';
import '../models/game_constants.dart'
    as model; // To avoid conflict with generated Card
import '../state/game_state.dart' as state;

class ClueClient {
  late ClueGameServiceClient _stub;
  late ClientChannel _channel;
  String? _gameId;
  List<String> _playerNames = [];

  ClueClient() {
    String host = 'localhost';
    if (!kIsWeb && Platform.isAndroid) {
      host = '10.0.2.2';
    }

    _channel = ClientChannel(
      host,
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _stub = ClueGameServiceClient(_channel);
  }

  Future<void> initializeGame(
    List<String> players,
    List<model.GameCard> userHand,
  ) async {
    _playerNames = List.from(players);
    final request = InitGameRequest()..numPlayers = players.length;

    request.playerNames.addAll(players);

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

    final turnData = TurnData()
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

    final request = TurnRequest()
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

  Future<GameStateResponse> fetchGameState() async {
    if (_gameId == null) {
      debugPrint('Game ID is null, cannot fetch game state.');
      return GameStateResponse(); // Return empty
    }
    final request = GameStateRequest()..gameId = _gameId!;

    try {
      return await _stub.getGameState(request);
    } catch (e) {
      debugPrint('Error fetching game state: $e');
      rethrow;
    }
  }

  // Helper to find index
  int _getPlayerIndex(String name) {
    int index = _playerNames.indexOf(name);
    if (index == -1) {
       debugPrint("Warning: Player $name not found in local list $_playerNames");
       return 0; // Default or throw?
    }
    return index;
  }

  Future<void> shutdown() async {
    await _channel.shutdown();
  }

  Card _convertToProtoCard(model.GameCard card) {
    final protoCard = Card();

    if (card.type == model.CardType.suspect) {
      protoCard.type = CardType.CARD_TYPE_SUSPECT;
      protoCard.suspect = _mapSuspect(card.name);
    } else if (card.type == model.CardType.weapon) {
      protoCard.type = CardType.CARD_TYPE_WEAPON;
      protoCard.weapon = _mapWeapon(card.name);
    } else if (card.type == model.CardType.room) {
      protoCard.type = CardType.CARD_TYPE_ROOM;
      protoCard.room = _mapRoom(card.name);
    }

    return protoCard;
  }

  Suspect _mapSuspect(String name) {
    switch (name) {
      case 'Colonel Mustard':
        return Suspect.SUSPECT_COL_MUSTARD;
      case 'Professor Plum':
        return Suspect.SUSPECT_PROF_PLUM;
      case 'Mr. Green':
        return Suspect.SUSPECT_MR_GREEN;
      case 'Mrs. Peacock':
        return Suspect.SUSPECT_MRS_PEACOCK;
      case 'Miss Scarlet':
        return Suspect.SUSPECT_MISS_SCARLET;
      case 'Mrs. White':
        return Suspect.SUSPECT_MRS_WHITE;
      default:
        return Suspect.SUSPECT_UNKNOWN;
    }
  }

  Weapon _mapWeapon(String name) {
    switch (name) {
      case 'Knife':
        return Weapon.WEAPON_KNIFE;
      case 'Candlestick':
        return Weapon.WEAPON_CANDLESTICK;
      case 'Revolver':
        return Weapon.WEAPON_REVOLVER;
      case 'Rope':
        return Weapon.WEAPON_ROPE;
      case 'Lead Pipe':
        return Weapon.WEAPON_LEAD_PIPE;
      case 'Wrench':
        return Weapon.WEAPON_WRENCH;
      default:
        return Weapon.WEAPON_UNKNOWN;
    }
  }

  Room _mapRoom(String name) {
    switch (name) {
      case 'Hall':
        return Room.ROOM_HALL;
      case 'Lounge':
        return Room.ROOM_LOUNGE;
      case 'Dining Room':
        return Room.ROOM_DINING_ROOM;
      case 'Kitchen':
        return Room.ROOM_KITCHEN;
      case 'Ballroom':
        return Room.ROOM_BALLROOM;
      case 'Conservatory':
        return Room.ROOM_CONSERVATORY;
      case 'Billiard Room':
        return Room.ROOM_BILLIARD_ROOM;
      case 'Library':
        return Room.ROOM_LIBRARY;
      case 'Study':
        return Room.ROOM_STUDY;
      default:
        return Room.ROOM_UNKNOWN;
    }
  }
}
