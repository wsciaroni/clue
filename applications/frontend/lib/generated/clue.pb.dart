// This is a generated file - do not edit.
//
// Generated from clue.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'clue.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'clue.pbenum.dart';

class GameStatusRequest extends $pb.GeneratedMessage {
  factory GameStatusRequest({
    $core.String? gameId,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    return result;
  }

  GameStatusRequest._();

  factory GameStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GameStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GameStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameStatusRequest copyWith(void Function(GameStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GameStatusRequest))
          as GameStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameStatusRequest create() => GameStatusRequest._();
  @$core.override
  GameStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GameStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GameStatusRequest>(create);
  static GameStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);
}

class GameStatusResponse extends $pb.GeneratedMessage {
  factory GameStatusResponse({
    $core.String? status,
    $core.bool? isActive,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (isActive != null) result.isActive = isActive;
    return result;
  }

  GameStatusResponse._();

  factory GameStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GameStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GameStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..aOB(2, _omitFieldNames ? '' : 'isActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameStatusResponse copyWith(void Function(GameStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GameStatusResponse))
          as GameStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameStatusResponse create() => GameStatusResponse._();
  @$core.override
  GameStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GameStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GameStatusResponse>(create);
  static GameStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isActive => $_getBF(1);
  @$pb.TagNumber(2)
  set isActive($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsActive() => $_clearField(2);
}

class InitGameRequest extends $pb.GeneratedMessage {
  factory InitGameRequest({
    $core.int? numPlayers,
    $core.Iterable<$core.String>? playerNames,
    $core.Iterable<Card>? myCards,
  }) {
    final result = create();
    if (numPlayers != null) result.numPlayers = numPlayers;
    if (playerNames != null) result.playerNames.addAll(playerNames);
    if (myCards != null) result.myCards.addAll(myCards);
    return result;
  }

  InitGameRequest._();

  factory InitGameRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InitGameRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InitGameRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'numPlayers')
    ..pPS(2, _omitFieldNames ? '' : 'playerNames')
    ..pPM<Card>(3, _omitFieldNames ? '' : 'myCards', subBuilder: Card.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitGameRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitGameRequest copyWith(void Function(InitGameRequest) updates) =>
      super.copyWith((message) => updates(message as InitGameRequest))
          as InitGameRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InitGameRequest create() => InitGameRequest._();
  @$core.override
  InitGameRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InitGameRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InitGameRequest>(create);
  static InitGameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get numPlayers => $_getIZ(0);
  @$pb.TagNumber(1)
  set numPlayers($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNumPlayers() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumPlayers() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get playerNames => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Card> get myCards => $_getList(2);
}

class InitGameResponse extends $pb.GeneratedMessage {
  factory InitGameResponse({
    $core.String? gameId,
    $core.bool? success,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    if (success != null) result.success = success;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  InitGameResponse._();

  factory InitGameResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InitGameResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InitGameResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..aOS(3, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitGameResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitGameResponse copyWith(void Function(InitGameResponse) updates) =>
      super.copyWith((message) => updates(message as InitGameResponse))
          as InitGameResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InitGameResponse create() => InitGameResponse._();
  @$core.override
  InitGameResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InitGameResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InitGameResponse>(create);
  static InitGameResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get errorMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMessage($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMessage() => $_clearField(3);
}

class TurnRequest extends $pb.GeneratedMessage {
  factory TurnRequest({
    $core.String? gameId,
    $core.String? suggester,
    Card? suggestionSuspect,
    Card? suggestionWeapon,
    Card? suggestionRoom,
    $core.String? responder,
    $core.bool? cardShown,
    Card? shownCard,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    if (suggester != null) result.suggester = suggester;
    if (suggestionSuspect != null) result.suggestionSuspect = suggestionSuspect;
    if (suggestionWeapon != null) result.suggestionWeapon = suggestionWeapon;
    if (suggestionRoom != null) result.suggestionRoom = suggestionRoom;
    if (responder != null) result.responder = responder;
    if (cardShown != null) result.cardShown = cardShown;
    if (shownCard != null) result.shownCard = shownCard;
    return result;
  }

  TurnRequest._();

  factory TurnRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..aOS(2, _omitFieldNames ? '' : 'suggester')
    ..aOM<Card>(3, _omitFieldNames ? '' : 'suggestionSuspect',
        subBuilder: Card.create)
    ..aOM<Card>(4, _omitFieldNames ? '' : 'suggestionWeapon',
        subBuilder: Card.create)
    ..aOM<Card>(5, _omitFieldNames ? '' : 'suggestionRoom',
        subBuilder: Card.create)
    ..aOS(6, _omitFieldNames ? '' : 'responder')
    ..aOB(7, _omitFieldNames ? '' : 'cardShown')
    ..aOM<Card>(8, _omitFieldNames ? '' : 'shownCard', subBuilder: Card.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnRequest copyWith(void Function(TurnRequest) updates) =>
      super.copyWith((message) => updates(message as TurnRequest))
          as TurnRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnRequest create() => TurnRequest._();
  @$core.override
  TurnRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TurnRequest>(create);
  static TurnRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get suggester => $_getSZ(1);
  @$pb.TagNumber(2)
  set suggester($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuggester() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuggester() => $_clearField(2);

  @$pb.TagNumber(3)
  Card get suggestionSuspect => $_getN(2);
  @$pb.TagNumber(3)
  set suggestionSuspect(Card value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSuggestionSuspect() => $_has(2);
  @$pb.TagNumber(3)
  void clearSuggestionSuspect() => $_clearField(3);
  @$pb.TagNumber(3)
  Card ensureSuggestionSuspect() => $_ensure(2);

  @$pb.TagNumber(4)
  Card get suggestionWeapon => $_getN(3);
  @$pb.TagNumber(4)
  set suggestionWeapon(Card value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSuggestionWeapon() => $_has(3);
  @$pb.TagNumber(4)
  void clearSuggestionWeapon() => $_clearField(4);
  @$pb.TagNumber(4)
  Card ensureSuggestionWeapon() => $_ensure(3);

  @$pb.TagNumber(5)
  Card get suggestionRoom => $_getN(4);
  @$pb.TagNumber(5)
  set suggestionRoom(Card value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSuggestionRoom() => $_has(4);
  @$pb.TagNumber(5)
  void clearSuggestionRoom() => $_clearField(5);
  @$pb.TagNumber(5)
  Card ensureSuggestionRoom() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get responder => $_getSZ(5);
  @$pb.TagNumber(6)
  set responder($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResponder() => $_has(5);
  @$pb.TagNumber(6)
  void clearResponder() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get cardShown => $_getBF(6);
  @$pb.TagNumber(7)
  set cardShown($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCardShown() => $_has(6);
  @$pb.TagNumber(7)
  void clearCardShown() => $_clearField(7);

  @$pb.TagNumber(8)
  Card get shownCard => $_getN(7);
  @$pb.TagNumber(8)
  set shownCard(Card value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasShownCard() => $_has(7);
  @$pb.TagNumber(8)
  void clearShownCard() => $_clearField(8);
  @$pb.TagNumber(8)
  Card ensureShownCard() => $_ensure(7);
}

class TurnResponse extends $pb.GeneratedMessage {
  factory TurnResponse({
    $core.bool? success,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  TurnResponse._();

  factory TurnResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnResponse copyWith(void Function(TurnResponse) updates) =>
      super.copyWith((message) => updates(message as TurnResponse))
          as TurnResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnResponse create() => TurnResponse._();
  @$core.override
  TurnResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TurnResponse>(create);
  static TurnResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);
}

class DeductionRequest extends $pb.GeneratedMessage {
  factory DeductionRequest({
    $core.String? gameId,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    return result;
  }

  DeductionRequest._();

  factory DeductionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeductionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeductionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeductionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeductionRequest copyWith(void Function(DeductionRequest) updates) =>
      super.copyWith((message) => updates(message as DeductionRequest))
          as DeductionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeductionRequest create() => DeductionRequest._();
  @$core.override
  DeductionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeductionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeductionRequest>(create);
  static DeductionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);
}

class DeductionResponse extends $pb.GeneratedMessage {
  factory DeductionResponse({
    $core.Iterable<CardKnowledge>? knowledge,
  }) {
    final result = create();
    if (knowledge != null) result.knowledge.addAll(knowledge);
    return result;
  }

  DeductionResponse._();

  factory DeductionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeductionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeductionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..pPM<CardKnowledge>(1, _omitFieldNames ? '' : 'knowledge',
        subBuilder: CardKnowledge.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeductionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeductionResponse copyWith(void Function(DeductionResponse) updates) =>
      super.copyWith((message) => updates(message as DeductionResponse))
          as DeductionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeductionResponse create() => DeductionResponse._();
  @$core.override
  DeductionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeductionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeductionResponse>(create);
  static DeductionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CardKnowledge> get knowledge => $_getList(0);
}

class CardKnowledge extends $pb.GeneratedMessage {
  factory CardKnowledge({
    $core.String? playerName,
    Card? card,
    DeductionStatus? status,
  }) {
    final result = create();
    if (playerName != null) result.playerName = playerName;
    if (card != null) result.card = card;
    if (status != null) result.status = status;
    return result;
  }

  CardKnowledge._();

  factory CardKnowledge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CardKnowledge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardKnowledge',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playerName')
    ..aOM<Card>(2, _omitFieldNames ? '' : 'card', subBuilder: Card.create)
    ..aE<DeductionStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: DeductionStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardKnowledge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardKnowledge copyWith(void Function(CardKnowledge) updates) =>
      super.copyWith((message) => updates(message as CardKnowledge))
          as CardKnowledge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CardKnowledge create() => CardKnowledge._();
  @$core.override
  CardKnowledge createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CardKnowledge getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CardKnowledge>(create);
  static CardKnowledge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playerName => $_getSZ(0);
  @$pb.TagNumber(1)
  set playerName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayerName() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerName() => $_clearField(1);

  @$pb.TagNumber(2)
  Card get card => $_getN(1);
  @$pb.TagNumber(2)
  set card(Card value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCard() => $_has(1);
  @$pb.TagNumber(2)
  void clearCard() => $_clearField(2);
  @$pb.TagNumber(2)
  Card ensureCard() => $_ensure(1);

  @$pb.TagNumber(3)
  DeductionStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(DeductionStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);
}

class Card extends $pb.GeneratedMessage {
  factory Card({
    $core.String? name,
    CardType? type,
    Suspect? suspect,
    Weapon? weapon,
    Room? room,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (type != null) result.type = type;
    if (suspect != null) result.suspect = suspect;
    if (weapon != null) result.weapon = weapon;
    if (room != null) result.room = room;
    return result;
  }

  Card._();

  factory Card.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Card.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Card',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aE<CardType>(2, _omitFieldNames ? '' : 'type',
        enumValues: CardType.values)
    ..aE<Suspect>(3, _omitFieldNames ? '' : 'suspect',
        enumValues: Suspect.values)
    ..aE<Weapon>(4, _omitFieldNames ? '' : 'weapon', enumValues: Weapon.values)
    ..aE<Room>(5, _omitFieldNames ? '' : 'room', enumValues: Room.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Card clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Card copyWith(void Function(Card) updates) =>
      super.copyWith((message) => updates(message as Card)) as Card;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Card create() => Card._();
  @$core.override
  Card createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Card getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Card>(create);
  static Card? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  CardType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(CardType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  /// One of the specific enums will be set based on type, or we use a universal ID.
  /// For simplicity in logic, we might rely on a global enum or just use these.
  /// Let's use a oneof or just simple fields if we want to carry the enum value.
  @$pb.TagNumber(3)
  Suspect get suspect => $_getN(2);
  @$pb.TagNumber(3)
  set suspect(Suspect value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSuspect() => $_has(2);
  @$pb.TagNumber(3)
  void clearSuspect() => $_clearField(3);

  @$pb.TagNumber(4)
  Weapon get weapon => $_getN(3);
  @$pb.TagNumber(4)
  set weapon(Weapon value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasWeapon() => $_has(3);
  @$pb.TagNumber(4)
  void clearWeapon() => $_clearField(4);

  @$pb.TagNumber(5)
  Room get room => $_getN(4);
  @$pb.TagNumber(5)
  set room(Room value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRoom() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoom() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
