///
//  Generated code. Do not modify.
//  source: clue.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'clue.pbenum.dart';

export 'clue.pbenum.dart';

class GameStatusRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameStatusRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId')
    ..hasRequiredFields = false
  ;

  GameStatusRequest._() : super();
  factory GameStatusRequest({
    $core.String? gameId,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    return _result;
  }
  factory GameStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameStatusRequest clone() => GameStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameStatusRequest copyWith(void Function(GameStatusRequest) updates) => super.copyWith((message) => updates(message as GameStatusRequest)) as GameStatusRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameStatusRequest create() => GameStatusRequest._();
  GameStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GameStatusRequest> createRepeated() => $pb.PbList<GameStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static GameStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameStatusRequest>(create);
  static GameStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);
}

class GameStatusResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameStatusResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isActive')
    ..hasRequiredFields = false
  ;

  GameStatusResponse._() : super();
  factory GameStatusResponse({
    $core.String? status,
    $core.bool? isActive,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (isActive != null) {
      _result.isActive = isActive;
    }
    return _result;
  }
  factory GameStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameStatusResponse clone() => GameStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameStatusResponse copyWith(void Function(GameStatusResponse) updates) => super.copyWith((message) => updates(message as GameStatusResponse)) as GameStatusResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameStatusResponse create() => GameStatusResponse._();
  GameStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GameStatusResponse> createRepeated() => $pb.PbList<GameStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static GameStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameStatusResponse>(create);
  static GameStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isActive => $_getBF(1);
  @$pb.TagNumber(2)
  set isActive($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsActive() => clearField(2);
}

class InitGameRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InitGameRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'numPlayers', $pb.PbFieldType.O3)
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerNames')
    ..pc<Card>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'myCards', $pb.PbFieldType.PM, subBuilder: Card.create)
    ..hasRequiredFields = false
  ;

  InitGameRequest._() : super();
  factory InitGameRequest({
    $core.int? numPlayers,
    $core.Iterable<$core.String>? playerNames,
    $core.Iterable<Card>? myCards,
  }) {
    final _result = create();
    if (numPlayers != null) {
      _result.numPlayers = numPlayers;
    }
    if (playerNames != null) {
      _result.playerNames.addAll(playerNames);
    }
    if (myCards != null) {
      _result.myCards.addAll(myCards);
    }
    return _result;
  }
  factory InitGameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InitGameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InitGameRequest clone() => InitGameRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InitGameRequest copyWith(void Function(InitGameRequest) updates) => super.copyWith((message) => updates(message as InitGameRequest)) as InitGameRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InitGameRequest create() => InitGameRequest._();
  InitGameRequest createEmptyInstance() => create();
  static $pb.PbList<InitGameRequest> createRepeated() => $pb.PbList<InitGameRequest>();
  @$core.pragma('dart2js:noInline')
  static InitGameRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InitGameRequest>(create);
  static InitGameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get numPlayers => $_getIZ(0);
  @$pb.TagNumber(1)
  set numPlayers($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNumPlayers() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumPlayers() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get playerNames => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<Card> get myCards => $_getList(2);
}

class InitGameResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InitGameResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMessage')
    ..hasRequiredFields = false
  ;

  InitGameResponse._() : super();
  factory InitGameResponse({
    $core.String? gameId,
    $core.bool? success,
    $core.String? errorMessage,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    if (success != null) {
      _result.success = success;
    }
    if (errorMessage != null) {
      _result.errorMessage = errorMessage;
    }
    return _result;
  }
  factory InitGameResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InitGameResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InitGameResponse clone() => InitGameResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InitGameResponse copyWith(void Function(InitGameResponse) updates) => super.copyWith((message) => updates(message as InitGameResponse)) as InitGameResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InitGameResponse create() => InitGameResponse._();
  InitGameResponse createEmptyInstance() => create();
  static $pb.PbList<InitGameResponse> createRepeated() => $pb.PbList<InitGameResponse>();
  @$core.pragma('dart2js:noInline')
  static InitGameResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InitGameResponse>(create);
  static InitGameResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get errorMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMessage($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasErrorMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMessage() => clearField(3);
}

class TurnRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TurnRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'suggester')
    ..aOM<Card>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'suggestionSuspect', subBuilder: Card.create)
    ..aOM<Card>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'suggestionWeapon', subBuilder: Card.create)
    ..aOM<Card>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'suggestionRoom', subBuilder: Card.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'responder')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cardShown')
    ..aOM<Card>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'shownCard', subBuilder: Card.create)
    ..hasRequiredFields = false
  ;

  TurnRequest._() : super();
  factory TurnRequest({
    $core.String? suggester,
    Card? suggestionSuspect,
    Card? suggestionWeapon,
    Card? suggestionRoom,
    $core.String? responder,
    $core.bool? cardShown,
    Card? shownCard,
  }) {
    final _result = create();
    if (suggester != null) {
      _result.suggester = suggester;
    }
    if (suggestionSuspect != null) {
      _result.suggestionSuspect = suggestionSuspect;
    }
    if (suggestionWeapon != null) {
      _result.suggestionWeapon = suggestionWeapon;
    }
    if (suggestionRoom != null) {
      _result.suggestionRoom = suggestionRoom;
    }
    if (responder != null) {
      _result.responder = responder;
    }
    if (cardShown != null) {
      _result.cardShown = cardShown;
    }
    if (shownCard != null) {
      _result.shownCard = shownCard;
    }
    return _result;
  }
  factory TurnRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TurnRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TurnRequest clone() => TurnRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TurnRequest copyWith(void Function(TurnRequest) updates) => super.copyWith((message) => updates(message as TurnRequest)) as TurnRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TurnRequest create() => TurnRequest._();
  TurnRequest createEmptyInstance() => create();
  static $pb.PbList<TurnRequest> createRepeated() => $pb.PbList<TurnRequest>();
  @$core.pragma('dart2js:noInline')
  static TurnRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TurnRequest>(create);
  static TurnRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get suggester => $_getSZ(0);
  @$pb.TagNumber(1)
  set suggester($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuggester() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuggester() => clearField(1);

  @$pb.TagNumber(2)
  Card get suggestionSuspect => $_getN(1);
  @$pb.TagNumber(2)
  set suggestionSuspect(Card v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSuggestionSuspect() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuggestionSuspect() => clearField(2);
  @$pb.TagNumber(2)
  Card ensureSuggestionSuspect() => $_ensure(1);

  @$pb.TagNumber(3)
  Card get suggestionWeapon => $_getN(2);
  @$pb.TagNumber(3)
  set suggestionWeapon(Card v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSuggestionWeapon() => $_has(2);
  @$pb.TagNumber(3)
  void clearSuggestionWeapon() => clearField(3);
  @$pb.TagNumber(3)
  Card ensureSuggestionWeapon() => $_ensure(2);

  @$pb.TagNumber(4)
  Card get suggestionRoom => $_getN(3);
  @$pb.TagNumber(4)
  set suggestionRoom(Card v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSuggestionRoom() => $_has(3);
  @$pb.TagNumber(4)
  void clearSuggestionRoom() => clearField(4);
  @$pb.TagNumber(4)
  Card ensureSuggestionRoom() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get responder => $_getSZ(4);
  @$pb.TagNumber(5)
  set responder($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasResponder() => $_has(4);
  @$pb.TagNumber(5)
  void clearResponder() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get cardShown => $_getBF(5);
  @$pb.TagNumber(6)
  set cardShown($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCardShown() => $_has(5);
  @$pb.TagNumber(6)
  void clearCardShown() => clearField(6);

  @$pb.TagNumber(7)
  Card get shownCard => $_getN(6);
  @$pb.TagNumber(7)
  set shownCard(Card v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasShownCard() => $_has(6);
  @$pb.TagNumber(7)
  void clearShownCard() => clearField(7);
  @$pb.TagNumber(7)
  Card ensureShownCard() => $_ensure(6);
}

class TurnResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TurnResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorMessage')
    ..hasRequiredFields = false
  ;

  TurnResponse._() : super();
  factory TurnResponse({
    $core.bool? success,
    $core.String? errorMessage,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (errorMessage != null) {
      _result.errorMessage = errorMessage;
    }
    return _result;
  }
  factory TurnResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TurnResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TurnResponse clone() => TurnResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TurnResponse copyWith(void Function(TurnResponse) updates) => super.copyWith((message) => updates(message as TurnResponse)) as TurnResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TurnResponse create() => TurnResponse._();
  TurnResponse createEmptyInstance() => create();
  static $pb.PbList<TurnResponse> createRepeated() => $pb.PbList<TurnResponse>();
  @$core.pragma('dart2js:noInline')
  static TurnResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TurnResponse>(create);
  static TurnResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => clearField(2);
}

class DeductionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeductionRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId')
    ..hasRequiredFields = false
  ;

  DeductionRequest._() : super();
  factory DeductionRequest({
    $core.String? gameId,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    return _result;
  }
  factory DeductionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeductionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeductionRequest clone() => DeductionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeductionRequest copyWith(void Function(DeductionRequest) updates) => super.copyWith((message) => updates(message as DeductionRequest)) as DeductionRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeductionRequest create() => DeductionRequest._();
  DeductionRequest createEmptyInstance() => create();
  static $pb.PbList<DeductionRequest> createRepeated() => $pb.PbList<DeductionRequest>();
  @$core.pragma('dart2js:noInline')
  static DeductionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeductionRequest>(create);
  static DeductionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);
}

class DeductionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeductionResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..pc<CardKnowledge>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'knowledge', $pb.PbFieldType.PM, subBuilder: CardKnowledge.create)
    ..hasRequiredFields = false
  ;

  DeductionResponse._() : super();
  factory DeductionResponse({
    $core.Iterable<CardKnowledge>? knowledge,
  }) {
    final _result = create();
    if (knowledge != null) {
      _result.knowledge.addAll(knowledge);
    }
    return _result;
  }
  factory DeductionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeductionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeductionResponse clone() => DeductionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeductionResponse copyWith(void Function(DeductionResponse) updates) => super.copyWith((message) => updates(message as DeductionResponse)) as DeductionResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeductionResponse create() => DeductionResponse._();
  DeductionResponse createEmptyInstance() => create();
  static $pb.PbList<DeductionResponse> createRepeated() => $pb.PbList<DeductionResponse>();
  @$core.pragma('dart2js:noInline')
  static DeductionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeductionResponse>(create);
  static DeductionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CardKnowledge> get knowledge => $_getList(0);
}

class CardKnowledge extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CardKnowledge', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerName')
    ..aOM<Card>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'card', subBuilder: Card.create)
    ..e<DeductionStatus>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: DeductionStatus.UNKNOWN, valueOf: DeductionStatus.valueOf, enumValues: DeductionStatus.values)
    ..hasRequiredFields = false
  ;

  CardKnowledge._() : super();
  factory CardKnowledge({
    $core.String? playerName,
    Card? card,
    DeductionStatus? status,
  }) {
    final _result = create();
    if (playerName != null) {
      _result.playerName = playerName;
    }
    if (card != null) {
      _result.card = card;
    }
    if (status != null) {
      _result.status = status;
    }
    return _result;
  }
  factory CardKnowledge.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CardKnowledge.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CardKnowledge clone() => CardKnowledge()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CardKnowledge copyWith(void Function(CardKnowledge) updates) => super.copyWith((message) => updates(message as CardKnowledge)) as CardKnowledge; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CardKnowledge create() => CardKnowledge._();
  CardKnowledge createEmptyInstance() => create();
  static $pb.PbList<CardKnowledge> createRepeated() => $pb.PbList<CardKnowledge>();
  @$core.pragma('dart2js:noInline')
  static CardKnowledge getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CardKnowledge>(create);
  static CardKnowledge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playerName => $_getSZ(0);
  @$pb.TagNumber(1)
  set playerName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayerName() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerName() => clearField(1);

  @$pb.TagNumber(2)
  Card get card => $_getN(1);
  @$pb.TagNumber(2)
  set card(Card v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCard() => $_has(1);
  @$pb.TagNumber(2)
  void clearCard() => clearField(2);
  @$pb.TagNumber(2)
  Card ensureCard() => $_ensure(1);

  @$pb.TagNumber(3)
  DeductionStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(DeductionStatus v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);
}

class Card extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Card', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'clue'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..e<CardType>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: CardType.CARD_TYPE_UNKNOWN, valueOf: CardType.valueOf, enumValues: CardType.values)
    ..e<Suspect>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'suspect', $pb.PbFieldType.OE, defaultOrMaker: Suspect.SUSPECT_UNKNOWN, valueOf: Suspect.valueOf, enumValues: Suspect.values)
    ..e<Weapon>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'weapon', $pb.PbFieldType.OE, defaultOrMaker: Weapon.WEAPON_UNKNOWN, valueOf: Weapon.valueOf, enumValues: Weapon.values)
    ..e<Room>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'room', $pb.PbFieldType.OE, defaultOrMaker: Room.ROOM_UNKNOWN, valueOf: Room.valueOf, enumValues: Room.values)
    ..hasRequiredFields = false
  ;

  Card._() : super();
  factory Card({
    $core.String? name,
    CardType? type,
    Suspect? suspect,
    Weapon? weapon,
    Room? room,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (type != null) {
      _result.type = type;
    }
    if (suspect != null) {
      _result.suspect = suspect;
    }
    if (weapon != null) {
      _result.weapon = weapon;
    }
    if (room != null) {
      _result.room = room;
    }
    return _result;
  }
  factory Card.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Card.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Card clone() => Card()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Card copyWith(void Function(Card) updates) => super.copyWith((message) => updates(message as Card)) as Card; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Card create() => Card._();
  Card createEmptyInstance() => create();
  static $pb.PbList<Card> createRepeated() => $pb.PbList<Card>();
  @$core.pragma('dart2js:noInline')
  static Card getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Card>(create);
  static Card? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  CardType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(CardType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  Suspect get suspect => $_getN(2);
  @$pb.TagNumber(3)
  set suspect(Suspect v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSuspect() => $_has(2);
  @$pb.TagNumber(3)
  void clearSuspect() => clearField(3);

  @$pb.TagNumber(4)
  Weapon get weapon => $_getN(3);
  @$pb.TagNumber(4)
  set weapon(Weapon v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasWeapon() => $_has(3);
  @$pb.TagNumber(4)
  void clearWeapon() => clearField(4);

  @$pb.TagNumber(5)
  Room get room => $_getN(4);
  @$pb.TagNumber(5)
  set room(Room v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasRoom() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoom() => clearField(5);
}
