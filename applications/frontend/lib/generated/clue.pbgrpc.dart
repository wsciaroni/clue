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

  $grpc.ResponseFuture<$0.GameStatusResponse> getGameStatus(
    $0.GameStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getGameStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.InitGameResponse> initGame(
    $0.InitGameRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$initGame, request, options: options);
  }

  $grpc.ResponseFuture<$0.TurnResponse> recordTurn(
    $0.TurnRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$recordTurn, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeductionResponse> getDeductions(
    $0.DeductionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDeductions, request, options: options);
  }

  // method descriptors

  static final _$getGameStatus =
      $grpc.ClientMethod<$0.GameStatusRequest, $0.GameStatusResponse>(
          '/clue.ClueGameService/GetGameStatus',
          ($0.GameStatusRequest value) => value.writeToBuffer(),
          $0.GameStatusResponse.fromBuffer);
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
  static final _$getDeductions =
      $grpc.ClientMethod<$0.DeductionRequest, $0.DeductionResponse>(
          '/clue.ClueGameService/GetDeductions',
          ($0.DeductionRequest value) => value.writeToBuffer(),
          $0.DeductionResponse.fromBuffer);
}

@$pb.GrpcServiceName('clue.ClueGameService')
abstract class ClueGameServiceBase extends $grpc.Service {
  $core.String get $name => 'clue.ClueGameService';

  ClueGameServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GameStatusRequest, $0.GameStatusResponse>(
        'GetGameStatus',
        getGameStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GameStatusRequest.fromBuffer(value),
        ($0.GameStatusResponse value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.DeductionRequest, $0.DeductionResponse>(
        'GetDeductions',
        getDeductions_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeductionRequest.fromBuffer(value),
        ($0.DeductionResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GameStatusResponse> getGameStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GameStatusRequest> $request) async {
    return getGameStatus($call, await $request);
  }

  $async.Future<$0.GameStatusResponse> getGameStatus(
      $grpc.ServiceCall call, $0.GameStatusRequest request);

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

  $async.Future<$0.DeductionResponse> getDeductions_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeductionRequest> $request) async {
    return getDeductions($call, await $request);
  }

  $async.Future<$0.DeductionResponse> getDeductions(
      $grpc.ServiceCall call, $0.DeductionRequest request);
}
