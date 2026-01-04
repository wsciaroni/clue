///
//  Generated code. Do not modify.
//  source: clue.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name,dangling_library_doc_comments

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'clue.pb.dart' as $0;
export 'clue.pb.dart';

class ClueGameServiceClient extends $grpc.Client {
  static final _$getGameStatus = $grpc.ClientMethod<$0.GameStatusRequest, $0.GameStatusResponse>(
      '/clue.ClueGameService/GetGameStatus',
      ($0.GameStatusRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GameStatusResponse.fromBuffer(value));
  static final _$initGame = $grpc.ClientMethod<$0.InitGameRequest, $0.InitGameResponse>(
      '/clue.ClueGameService/InitGame',
      ($0.InitGameRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.InitGameResponse.fromBuffer(value));
  static final _$recordTurn = $grpc.ClientMethod<$0.TurnRequest, $0.TurnResponse>(
      '/clue.ClueGameService/RecordTurn',
      ($0.TurnRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.TurnResponse.fromBuffer(value));
  static final _$getDeductions = $grpc.ClientMethod<$0.DeductionRequest, $0.DeductionResponse>(
      '/clue.ClueGameService/GetDeductions',
      ($0.DeductionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DeductionResponse.fromBuffer(value));

  ClueGameServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.GameStatusResponse> getGameStatus($0.GameStatusRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getGameStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.InitGameResponse> initGame($0.InitGameRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$initGame, request, options: options);
  }

  $grpc.ResponseFuture<$0.TurnResponse> recordTurn($0.TurnRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$recordTurn, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeductionResponse> getDeductions($0.DeductionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getDeductions, request, options: options);
  }
}
