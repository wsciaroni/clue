// This is a generated file - do not edit.
//
// Generated from clue.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'clue.pb.dart' as $0;

export 'clue.pb.dart';

@$pb.GrpcServiceName('clue.ClueGameService')
class ClueGameServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ClueGameServiceClient(super.channel, {super.options, super.interceptors});

  /// Initialize a new session
  $grpc.ResponseFuture<$0.InitGameResponse> initGame(
    $0.InitGameRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$initGame, request, options: options);
  }

  /// Appends a new turn to the history and updates state
  $grpc.ResponseFuture<$0.TurnResponse> recordTurn(
    $0.TurnRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$recordTurn, request, options: options);
  }

  /// Modifies an existing turn in the history and REPLAYS the game state
  $grpc.ResponseFuture<$0.TurnResponse> updateTurn(
    $0.UpdateTurnRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateTurn, request, options: options);
  }

  /// Removes a specific turn by ID
  $grpc.ResponseFuture<$0.DeleteTurnResponse> deleteTurn(
    $0.DeleteTurnRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteTurn, request, options: options);
  }

  /// Removes the last turn
  $grpc.ResponseFuture<$0.UndoResponse> undoLastTurn(
    $0.UndoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$undoLastTurn, request, options: options);
  }

  /// Returns list of turns (for UI "Edit" menu)
  $grpc.ResponseFuture<$0.GetHistoryResponse> getTurnHistory(
    $0.GetHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTurnHistory, request, options: options);
  }

  /// The Source of Truth. Frontend calls this to get the renderable grid.
  $grpc.ResponseFuture<$0.GameStateResponse> getGameState(
    $0.GameStateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getGameState, request, options: options);
  }

  // method descriptors

  static final _$initGame =
      $grpc.ClientMethod<$0.InitGameRequest, $0.InitGameResponse>(
          '/clue.ClueGameService/InitGame',
          ($0.InitGameRequest value) => value.writeToBuffer(),
          $0.InitGameResponse.fromBuffer);
  static final _$recordTurn =
      $grpc.ClientMethod<$0.TurnRequest, $0.TurnResponse>(
          '/clue.ClueGameService/RecordTurn',
          ($0.TurnRequest value) => value.writeToBuffer(),
          $0.TurnResponse.fromBuffer);
  static final _$updateTurn =
      $grpc.ClientMethod<$0.UpdateTurnRequest, $0.TurnResponse>(
          '/clue.ClueGameService/UpdateTurn',
          ($0.UpdateTurnRequest value) => value.writeToBuffer(),
          $0.TurnResponse.fromBuffer);
  static final _$deleteTurn =
      $grpc.ClientMethod<$0.DeleteTurnRequest, $0.DeleteTurnResponse>(
          '/clue.ClueGameService/DeleteTurn',
          ($0.DeleteTurnRequest value) => value.writeToBuffer(),
          $0.DeleteTurnResponse.fromBuffer);
  static final _$undoLastTurn =
      $grpc.ClientMethod<$0.UndoRequest, $0.UndoResponse>(
          '/clue.ClueGameService/UndoLastTurn',
          ($0.UndoRequest value) => value.writeToBuffer(),
          $0.UndoResponse.fromBuffer);
  static final _$getTurnHistory =
      $grpc.ClientMethod<$0.GetHistoryRequest, $0.GetHistoryResponse>(
          '/clue.ClueGameService/GetTurnHistory',
          ($0.GetHistoryRequest value) => value.writeToBuffer(),
          $0.GetHistoryResponse.fromBuffer);
  static final _$getGameState =
      $grpc.ClientMethod<$0.GameStateRequest, $0.GameStateResponse>(
          '/clue.ClueGameService/GetGameState',
          ($0.GameStateRequest value) => value.writeToBuffer(),
          $0.GameStateResponse.fromBuffer);
}

@$pb.GrpcServiceName('clue.ClueGameService')
abstract class ClueGameServiceBase extends $grpc.Service {
  $core.String get $name => 'clue.ClueGameService';

  ClueGameServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.InitGameRequest, $0.InitGameResponse>(
        'InitGame',
        initGame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.InitGameRequest.fromBuffer(value),
        ($0.InitGameResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TurnRequest, $0.TurnResponse>(
        'RecordTurn',
        recordTurn_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TurnRequest.fromBuffer(value),
        ($0.TurnResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateTurnRequest, $0.TurnResponse>(
        'UpdateTurn',
        updateTurn_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateTurnRequest.fromBuffer(value),
        ($0.TurnResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteTurnRequest, $0.DeleteTurnResponse>(
        'DeleteTurn',
        deleteTurn_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteTurnRequest.fromBuffer(value),
        ($0.DeleteTurnResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UndoRequest, $0.UndoResponse>(
        'UndoLastTurn',
        undoLastTurn_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UndoRequest.fromBuffer(value),
        ($0.UndoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetHistoryRequest, $0.GetHistoryResponse>(
        'GetTurnHistory',
        getTurnHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetHistoryRequest.fromBuffer(value),
        ($0.GetHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GameStateRequest, $0.GameStateResponse>(
        'GetGameState',
        getGameState_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GameStateRequest.fromBuffer(value),
        ($0.GameStateResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.InitGameResponse> initGame_Pre($grpc.ServiceCall $call,
      $async.Future<$0.InitGameRequest> $request) async {
    return initGame($call, await $request);
  }

  $async.Future<$0.InitGameResponse> initGame(
      $grpc.ServiceCall call, $0.InitGameRequest request);

  $async.Future<$0.TurnResponse> recordTurn_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.TurnRequest> $request) async {
    return recordTurn($call, await $request);
  }

  $async.Future<$0.TurnResponse> recordTurn(
      $grpc.ServiceCall call, $0.TurnRequest request);

  $async.Future<$0.TurnResponse> updateTurn_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateTurnRequest> $request) async {
    return updateTurn($call, await $request);
  }

  $async.Future<$0.TurnResponse> updateTurn(
      $grpc.ServiceCall call, $0.UpdateTurnRequest request);

  $async.Future<$0.DeleteTurnResponse> deleteTurn_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteTurnRequest> $request) async {
    return deleteTurn($call, await $request);
  }

  $async.Future<$0.DeleteTurnResponse> deleteTurn(
      $grpc.ServiceCall call, $0.DeleteTurnRequest request);

  $async.Future<$0.UndoResponse> undoLastTurn_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.UndoRequest> $request) async {
    return undoLastTurn($call, await $request);
  }

  $async.Future<$0.UndoResponse> undoLastTurn(
      $grpc.ServiceCall call, $0.UndoRequest request);

  $async.Future<$0.GetHistoryResponse> getTurnHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetHistoryRequest> $request) async {
    return getTurnHistory($call, await $request);
  }

  $async.Future<$0.GetHistoryResponse> getTurnHistory(
      $grpc.ServiceCall call, $0.GetHistoryRequest request);

  $async.Future<$0.GameStateResponse> getGameState_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GameStateRequest> $request) async {
    return getGameState($call, await $request);
  }

  $async.Future<$0.GameStateResponse> getGameState(
      $grpc.ServiceCall call, $0.GameStateRequest request);
}
