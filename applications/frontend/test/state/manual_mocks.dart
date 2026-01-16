import 'package:frontend/services/clue_client.dart';
import 'package:frontend/state/game_state.dart' as state;
import 'package:frontend/generated/clue.pb.dart' as proto;
import 'package:frontend/models/game_constants.dart' as model;
import 'package:mockito/mockito.dart';

class MockClueClient extends Mock implements ClueClient {
  @override
  Future<void> initializeGame(
    List<String>? players,
    List<model.GameCard>? userHand, {
    List<int>? cardCounts,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #initializeGame,
        [players, userHand],
        {#cardCounts: cardCounts},
      ),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }

  @override
  Future<proto.GameStateResponse> fetchGameState() {
    return super.noSuchMethod(
      Invocation.method(#fetchGameState, []),
      returnValue: Future.value(proto.GameStateResponse()),
      returnValueForMissingStub: Future.value(proto.GameStateResponse()),
    );
  }

  @override
  Future<void> submitTurn(state.GameTurn? turn) {
    return super.noSuchMethod(
      Invocation.method(#submitTurn, [turn]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }

  @override
  Future<List<proto.TurnEntry>> getTurnHistory() {
      return super.noSuchMethod(
        Invocation.method(#getTurnHistory, []),
        returnValue: Future.value(<proto.TurnEntry>[]),
        returnValueForMissingStub: Future.value(<proto.TurnEntry>[]),
      );
  }

  @override
  void connect({String? host, int? port}) {
     super.noSuchMethod(
       Invocation.method(#connect, [], {#host: host, #port: port}),
       returnValueForMissingStub: null,
     );
  }
}
