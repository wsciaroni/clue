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

enum Card_Value { suspect, weapon, room, notSet }

class Card extends $pb.GeneratedMessage {
  factory Card({
    CardType? type,
    Suspect? suspect,
    Weapon? weapon,
    Room? room,
  }) {
    final result = create();
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

  static const $core.Map<$core.int, Card_Value> _Card_ValueByTag = {
    2: Card_Value.suspect,
    3: Card_Value.weapon,
    4: Card_Value.room,
    0: Card_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Card',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aE<CardType>(1, _omitFieldNames ? '' : 'type',
        enumValues: CardType.values)
    ..aE<Suspect>(2, _omitFieldNames ? '' : 'suspect',
        enumValues: Suspect.values)
    ..aE<Weapon>(3, _omitFieldNames ? '' : 'weapon', enumValues: Weapon.values)
    ..aE<Room>(4, _omitFieldNames ? '' : 'room', enumValues: Room.values)
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

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  Card_Value whichValue() => _Card_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CardType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(CardType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  Suspect get suspect => $_getN(1);
  @$pb.TagNumber(2)
  set suspect(Suspect value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSuspect() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuspect() => $_clearField(2);

  @$pb.TagNumber(3)
  Weapon get weapon => $_getN(2);
  @$pb.TagNumber(3)
  set weapon(Weapon value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWeapon() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeapon() => $_clearField(3);

  @$pb.TagNumber(4)
  Room get room => $_getN(3);
  @$pb.TagNumber(4)
  set room(Room value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRoom() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoom() => $_clearField(4);
}

class TurnData extends $pb.GeneratedMessage {
  factory TurnData({
    $core.int? suggesterPlayerIndex,
    Card? suspect,
    Card? weapon,
    Card? room,
    $core.int? responderPlayerIndex,
    Card? cardShown,
  }) {
    final result = create();
    if (suggesterPlayerIndex != null)
      result.suggesterPlayerIndex = suggesterPlayerIndex;
    if (suspect != null) result.suspect = suspect;
    if (weapon != null) result.weapon = weapon;
    if (room != null) result.room = room;
    if (responderPlayerIndex != null)
      result.responderPlayerIndex = responderPlayerIndex;
    if (cardShown != null) result.cardShown = cardShown;
    return result;
  }

  TurnData._();

  factory TurnData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'suggesterPlayerIndex')
    ..aOM<Card>(2, _omitFieldNames ? '' : 'suspect', subBuilder: Card.create)
    ..aOM<Card>(3, _omitFieldNames ? '' : 'weapon', subBuilder: Card.create)
    ..aOM<Card>(4, _omitFieldNames ? '' : 'room', subBuilder: Card.create)
    ..aI(5, _omitFieldNames ? '' : 'responderPlayerIndex')
    ..aOM<Card>(6, _omitFieldNames ? '' : 'cardShown', subBuilder: Card.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnData copyWith(void Function(TurnData) updates) =>
      super.copyWith((message) => updates(message as TurnData)) as TurnData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnData create() => TurnData._();
  @$core.override
  TurnData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TurnData>(create);
  static TurnData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get suggesterPlayerIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set suggesterPlayerIndex($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuggesterPlayerIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuggesterPlayerIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  Card get suspect => $_getN(1);
  @$pb.TagNumber(2)
  set suspect(Card value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSuspect() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuspect() => $_clearField(2);
  @$pb.TagNumber(2)
  Card ensureSuspect() => $_ensure(1);

  @$pb.TagNumber(3)
  Card get weapon => $_getN(2);
  @$pb.TagNumber(3)
  set weapon(Card value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWeapon() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeapon() => $_clearField(3);
  @$pb.TagNumber(3)
  Card ensureWeapon() => $_ensure(2);

  @$pb.TagNumber(4)
  Card get room => $_getN(3);
  @$pb.TagNumber(4)
  set room(Card value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRoom() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoom() => $_clearField(4);
  @$pb.TagNumber(4)
  Card ensureRoom() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get responderPlayerIndex => $_getIZ(4);
  @$pb.TagNumber(5)
  set responderPlayerIndex($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasResponderPlayerIndex() => $_has(4);
  @$pb.TagNumber(5)
  void clearResponderPlayerIndex() => $_clearField(5);

  @$pb.TagNumber(6)
  Card get cardShown => $_getN(5);
  @$pb.TagNumber(6)
  set cardShown(Card value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCardShown() => $_has(5);
  @$pb.TagNumber(6)
  void clearCardShown() => $_clearField(6);
  @$pb.TagNumber(6)
  Card ensureCardShown() => $_ensure(5);
}

class TurnEntry extends $pb.GeneratedMessage {
  factory TurnEntry({
    $core.String? turnId,
    $core.int? turnNumber,
    TurnData? data,
  }) {
    final result = create();
    if (turnId != null) result.turnId = turnId;
    if (turnNumber != null) result.turnNumber = turnNumber;
    if (data != null) result.data = data;
    return result;
  }

  TurnEntry._();

  factory TurnEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TurnEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TurnEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'turnId')
    ..aI(2, _omitFieldNames ? '' : 'turnNumber')
    ..aOM<TurnData>(3, _omitFieldNames ? '' : 'data',
        subBuilder: TurnData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TurnEntry copyWith(void Function(TurnEntry) updates) =>
      super.copyWith((message) => updates(message as TurnEntry)) as TurnEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TurnEntry create() => TurnEntry._();
  @$core.override
  TurnEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TurnEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TurnEntry>(create);
  static TurnEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get turnId => $_getSZ(0);
  @$pb.TagNumber(1)
  set turnId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTurnId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTurnId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get turnNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set turnNumber($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTurnNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearTurnNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  TurnData get data => $_getN(2);
  @$pb.TagNumber(3)
  set data(TurnData value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => $_clearField(3);
  @$pb.TagNumber(3)
  TurnData ensureData() => $_ensure(2);
}

class PlayerInfo extends $pb.GeneratedMessage {
  factory PlayerInfo({
    $core.int? index,
    $core.String? name,
    $core.int? cardCount,
  }) {
    final result = create();
    if (index != null) result.index = index;
    if (name != null) result.name = name;
    if (cardCount != null) result.cardCount = cardCount;
    return result;
  }

  PlayerInfo._();

  factory PlayerInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'index')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'cardCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerInfo copyWith(void Function(PlayerInfo) updates) =>
      super.copyWith((message) => updates(message as PlayerInfo)) as PlayerInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerInfo create() => PlayerInfo._();
  @$core.override
  PlayerInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlayerInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerInfo>(create);
  static PlayerInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get cardCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set cardCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCardCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardCount() => $_clearField(3);
}

class CellState extends $pb.GeneratedMessage {
  factory CellState({
    CellState_Status? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  CellState._();

  factory CellState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CellState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CellState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aE<CellState_Status>(1, _omitFieldNames ? '' : 'status',
        enumValues: CellState_Status.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellState copyWith(void Function(CellState) updates) =>
      super.copyWith((message) => updates(message as CellState)) as CellState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CellState create() => CellState._();
  @$core.override
  CellState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CellState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CellState>(create);
  static CellState? _defaultInstance;

  @$pb.TagNumber(1)
  CellState_Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(CellState_Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
}

class GridRow extends $pb.GeneratedMessage {
  factory GridRow({
    Card? card,
    $core.Iterable<CellState>? playerStates,
  }) {
    final result = create();
    if (card != null) result.card = card;
    if (playerStates != null) result.playerStates.addAll(playerStates);
    return result;
  }

  GridRow._();

  factory GridRow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GridRow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GridRow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOM<Card>(1, _omitFieldNames ? '' : 'card', subBuilder: Card.create)
    ..pPM<CellState>(2, _omitFieldNames ? '' : 'playerStates',
        subBuilder: CellState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GridRow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GridRow copyWith(void Function(GridRow) updates) =>
      super.copyWith((message) => updates(message as GridRow)) as GridRow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GridRow create() => GridRow._();
  @$core.override
  GridRow createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GridRow getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GridRow>(create);
  static GridRow? _defaultInstance;

  @$pb.TagNumber(1)
  Card get card => $_getN(0);
  @$pb.TagNumber(1)
  set card(Card value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearCard() => $_clearField(1);
  @$pb.TagNumber(1)
  Card ensureCard() => $_ensure(0);

  /// State of this card for every player (ordered by player index)
  @$pb.TagNumber(2)
  $pb.PbList<CellState> get playerStates => $_getList(1);
}

class SolutionProbability extends $pb.GeneratedMessage {
  factory SolutionProbability({
    Card? card,
    $core.double? probability,
    $core.bool? isEliminated,
  }) {
    final result = create();
    if (card != null) result.card = card;
    if (probability != null) result.probability = probability;
    if (isEliminated != null) result.isEliminated = isEliminated;
    return result;
  }

  SolutionProbability._();

  factory SolutionProbability.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SolutionProbability.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SolutionProbability',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOM<Card>(1, _omitFieldNames ? '' : 'card', subBuilder: Card.create)
    ..aD(2, _omitFieldNames ? '' : 'probability', fieldType: $pb.PbFieldType.OF)
    ..aOB(3, _omitFieldNames ? '' : 'isEliminated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SolutionProbability clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SolutionProbability copyWith(void Function(SolutionProbability) updates) =>
      super.copyWith((message) => updates(message as SolutionProbability))
          as SolutionProbability;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SolutionProbability create() => SolutionProbability._();
  @$core.override
  SolutionProbability createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SolutionProbability getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SolutionProbability>(create);
  static SolutionProbability? _defaultInstance;

  @$pb.TagNumber(1)
  Card get card => $_getN(0);
  @$pb.TagNumber(1)
  set card(Card value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearCard() => $_clearField(1);
  @$pb.TagNumber(1)
  Card ensureCard() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get probability => $_getN(1);
  @$pb.TagNumber(2)
  set probability($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProbability() => $_has(1);
  @$pb.TagNumber(2)
  void clearProbability() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isEliminated => $_getBF(2);
  @$pb.TagNumber(3)
  set isEliminated($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsEliminated() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsEliminated() => $_clearField(3);
}

class InitGameRequest extends $pb.GeneratedMessage {
  factory InitGameRequest({
    $core.int? numPlayers,
    $core.Iterable<$core.String>? playerNames,
    $core.Iterable<Card>? myHand,
  }) {
    final result = create();
    if (numPlayers != null) result.numPlayers = numPlayers;
    if (playerNames != null) result.playerNames.addAll(playerNames);
    if (myHand != null) result.myHand.addAll(myHand);
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
    ..pPM<Card>(3, _omitFieldNames ? '' : 'myHand', subBuilder: Card.create)
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
  $pb.PbList<Card> get myHand => $_getList(2);
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
    TurnData? data,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    if (data != null) result.data = data;
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
    ..aOM<TurnData>(2, _omitFieldNames ? '' : 'data',
        subBuilder: TurnData.create)
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
  TurnData get data => $_getN(1);
  @$pb.TagNumber(2)
  set data(TurnData value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => $_clearField(2);
  @$pb.TagNumber(2)
  TurnData ensureData() => $_ensure(1);
}

class UpdateTurnRequest extends $pb.GeneratedMessage {
  factory UpdateTurnRequest({
    $core.String? gameId,
    $core.String? turnId,
    TurnData? newData,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    if (turnId != null) result.turnId = turnId;
    if (newData != null) result.newData = newData;
    return result;
  }

  UpdateTurnRequest._();

  factory UpdateTurnRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateTurnRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateTurnRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..aOS(2, _omitFieldNames ? '' : 'turnId')
    ..aOM<TurnData>(3, _omitFieldNames ? '' : 'newData',
        subBuilder: TurnData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTurnRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTurnRequest copyWith(void Function(UpdateTurnRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateTurnRequest))
          as UpdateTurnRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateTurnRequest create() => UpdateTurnRequest._();
  @$core.override
  UpdateTurnRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateTurnRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateTurnRequest>(create);
  static UpdateTurnRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get turnId => $_getSZ(1);
  @$pb.TagNumber(2)
  set turnId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTurnId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTurnId() => $_clearField(2);

  @$pb.TagNumber(3)
  TurnData get newData => $_getN(2);
  @$pb.TagNumber(3)
  set newData(TurnData value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewData() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewData() => $_clearField(3);
  @$pb.TagNumber(3)
  TurnData ensureNewData() => $_ensure(2);
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

class UndoRequest extends $pb.GeneratedMessage {
  factory UndoRequest({
    $core.String? gameId,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    return result;
  }

  UndoRequest._();

  factory UndoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UndoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UndoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UndoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UndoRequest copyWith(void Function(UndoRequest) updates) =>
      super.copyWith((message) => updates(message as UndoRequest))
          as UndoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UndoRequest create() => UndoRequest._();
  @$core.override
  UndoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UndoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UndoRequest>(create);
  static UndoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);
}

class UndoResponse extends $pb.GeneratedMessage {
  factory UndoResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  UndoResponse._();

  factory UndoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UndoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UndoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UndoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UndoResponse copyWith(void Function(UndoResponse) updates) =>
      super.copyWith((message) => updates(message as UndoResponse))
          as UndoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UndoResponse create() => UndoResponse._();
  @$core.override
  UndoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UndoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UndoResponse>(create);
  static UndoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class GetHistoryRequest extends $pb.GeneratedMessage {
  factory GetHistoryRequest({
    $core.String? gameId,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    return result;
  }

  GetHistoryRequest._();

  factory GetHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHistoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHistoryRequest copyWith(void Function(GetHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as GetHistoryRequest))
          as GetHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHistoryRequest create() => GetHistoryRequest._();
  @$core.override
  GetHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHistoryRequest>(create);
  static GetHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);
}

class GetHistoryResponse extends $pb.GeneratedMessage {
  factory GetHistoryResponse({
    $core.Iterable<TurnEntry>? history,
  }) {
    final result = create();
    if (history != null) result.history.addAll(history);
    return result;
  }

  GetHistoryResponse._();

  factory GetHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHistoryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..pPM<TurnEntry>(1, _omitFieldNames ? '' : 'history',
        subBuilder: TurnEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHistoryResponse copyWith(void Function(GetHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as GetHistoryResponse))
          as GetHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHistoryResponse create() => GetHistoryResponse._();
  @$core.override
  GetHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHistoryResponse>(create);
  static GetHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TurnEntry> get history => $_getList(0);
}

class GameStateRequest extends $pb.GeneratedMessage {
  factory GameStateRequest({
    $core.String? gameId,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    return result;
  }

  GameStateRequest._();

  factory GameStateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GameStateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GameStateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameStateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameStateRequest copyWith(void Function(GameStateRequest) updates) =>
      super.copyWith((message) => updates(message as GameStateRequest))
          as GameStateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameStateRequest create() => GameStateRequest._();
  @$core.override
  GameStateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GameStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GameStateRequest>(create);
  static GameStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);
}

class GameStateResponse extends $pb.GeneratedMessage {
  factory GameStateResponse({
    $core.String? gameId,
    $core.Iterable<PlayerInfo>? players,
    $core.Iterable<GridRow>? rows,
    $core.Iterable<SolutionProbability>? solutionProbabilities,
  }) {
    final result = create();
    if (gameId != null) result.gameId = gameId;
    if (players != null) result.players.addAll(players);
    if (rows != null) result.rows.addAll(rows);
    if (solutionProbabilities != null)
      result.solutionProbabilities.addAll(solutionProbabilities);
    return result;
  }

  GameStateResponse._();

  factory GameStateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GameStateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GameStateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'clue'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..pPM<PlayerInfo>(2, _omitFieldNames ? '' : 'players',
        subBuilder: PlayerInfo.create)
    ..pPM<GridRow>(3, _omitFieldNames ? '' : 'rows', subBuilder: GridRow.create)
    ..pPM<SolutionProbability>(
        4, _omitFieldNames ? '' : 'solutionProbabilities',
        subBuilder: SolutionProbability.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameStateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameStateResponse copyWith(void Function(GameStateResponse) updates) =>
      super.copyWith((message) => updates(message as GameStateResponse))
          as GameStateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameStateResponse create() => GameStateResponse._();
  @$core.override
  GameStateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GameStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GameStateResponse>(create);
  static GameStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<PlayerInfo> get players => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<GridRow> get rows => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<SolutionProbability> get solutionProbabilities => $_getList(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
