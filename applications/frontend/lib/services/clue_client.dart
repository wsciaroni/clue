import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import '../generated/clue.pbgrpc.dart';
import '../models/game_constants.dart' as model; // To avoid conflict with generated Card
import '../state/game_state.dart' as state;

class ClueClient {
  late ClueGameServiceClient _stub;
  late ClientChannel _channel;
  String? _gameId;

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

  Future<void> initializeGame(List<String> players, List<model.GameCard> userHand) async {
    final request = InitGameRequest()
      ..numPlayers = players.length;

    request.playerNames.addAll(players);

    // Convert model.GameCard to generated Card
    for (var card in userHand) {
      request.myCards.add(_convertToProtoCard(card));
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
    final request = TurnRequest()
      ..suggester = turn.askingPlayer.name
      ..suggestionSuspect = _convertToProtoCard(turn.suspect)
      ..suggestionWeapon = _convertToProtoCard(turn.weapon)
      ..suggestionRoom = _convertToProtoCard(turn.room)
      ..responder = turn.answeringPlayer.name
      ..cardShown = turn.cardShown;

    if (turn.specificCardShown != null) {
      request.shownCard = _convertToProtoCard(turn.specificCardShown!);
    }

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

  Future<DeductionResponse> fetchDeductions() async {
    if (_gameId == null) {
      debugPrint('Game ID is null, cannot fetch deductions.');
      return DeductionResponse(); // Return empty
    }
    final request = DeductionRequest()..gameId = _gameId!;

    try {
      return await _stub.getDeductions(request);
    } catch (e) {
      debugPrint('Error fetching deductions: $e');
      rethrow;
    }
  }

  Future<void> shutdown() async {
    await _channel.shutdown();
  }

  Card _convertToProtoCard(model.GameCard card) {
    final protoCard = Card()..name = card.name;

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
      case 'Colonel Mustard': return Suspect.SUSPECT_COL_MUSTARD;
      case 'Professor Plum': return Suspect.SUSPECT_PROF_PLUM;
      case 'Mr. Green': return Suspect.SUSPECT_MR_GREEN;
      case 'Mrs. Peacock': return Suspect.SUSPECT_MRS_PEACOCK;
      case 'Miss Scarlet': return Suspect.SUSPECT_MISS_SCARLET;
      case 'Mrs. White': return Suspect.SUSPECT_MRS_WHITE;
      default: return Suspect.SUSPECT_UNKNOWN;
    }
  }

  Weapon _mapWeapon(String name) {
    switch (name) {
      case 'Knife': return Weapon.WEAPON_KNIFE;
      case 'Candlestick': return Weapon.WEAPON_CANDLESTICK;
      case 'Revolver': return Weapon.WEAPON_REVOLVER;
      case 'Rope': return Weapon.WEAPON_ROPE;
      case 'Lead Pipe': return Weapon.WEAPON_LEAD_PIPE;
      case 'Wrench': return Weapon.WEAPON_WRENCH;
      default: return Weapon.WEAPON_UNKNOWN;
    }
  }

  Room _mapRoom(String name) {
    switch (name) {
      case 'Hall': return Room.ROOM_HALL;
      case 'Lounge': return Room.ROOM_LOUNGE;
      case 'Dining Room': return Room.ROOM_DINING_ROOM;
      case 'Kitchen': return Room.ROOM_KITCHEN;
      case 'Ballroom': return Room.ROOM_BALLROOM;
      case 'Conservatory': return Room.ROOM_CONSERVATORY;
      case 'Billiard Room': return Room.ROOM_BILLIARD_ROOM;
      case 'Library': return Room.ROOM_LIBRARY;
      case 'Study': return Room.ROOM_STUDY;
      default: return Room.ROOM_UNKNOWN;
    }
  }
}
