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

class CardType extends $pb.ProtobufEnum {
  static const CardType CARD_TYPE_UNKNOWN =
      CardType._(0, _omitEnumNames ? '' : 'CARD_TYPE_UNKNOWN');
  static const CardType CARD_TYPE_SUSPECT =
      CardType._(1, _omitEnumNames ? '' : 'CARD_TYPE_SUSPECT');
  static const CardType CARD_TYPE_WEAPON =
      CardType._(2, _omitEnumNames ? '' : 'CARD_TYPE_WEAPON');
  static const CardType CARD_TYPE_ROOM =
      CardType._(3, _omitEnumNames ? '' : 'CARD_TYPE_ROOM');

  static const $core.List<CardType> values = <CardType>[
    CARD_TYPE_UNKNOWN,
    CARD_TYPE_SUSPECT,
    CARD_TYPE_WEAPON,
    CARD_TYPE_ROOM,
  ];

  static final $core.List<CardType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CardType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CardType._(super.value, super.name);
}

class Suspect extends $pb.ProtobufEnum {
  static const Suspect SUSPECT_UNKNOWN =
      Suspect._(0, _omitEnumNames ? '' : 'SUSPECT_UNKNOWN');
  static const Suspect SUSPECT_COL_MUSTARD =
      Suspect._(1, _omitEnumNames ? '' : 'SUSPECT_COL_MUSTARD');
  static const Suspect SUSPECT_PROF_PLUM =
      Suspect._(2, _omitEnumNames ? '' : 'SUSPECT_PROF_PLUM');
  static const Suspect SUSPECT_MR_GREEN =
      Suspect._(3, _omitEnumNames ? '' : 'SUSPECT_MR_GREEN');
  static const Suspect SUSPECT_MRS_PEACOCK =
      Suspect._(4, _omitEnumNames ? '' : 'SUSPECT_MRS_PEACOCK');
  static const Suspect SUSPECT_MISS_SCARLET =
      Suspect._(5, _omitEnumNames ? '' : 'SUSPECT_MISS_SCARLET');
  static const Suspect SUSPECT_MRS_WHITE =
      Suspect._(6, _omitEnumNames ? '' : 'SUSPECT_MRS_WHITE');

  static const $core.List<Suspect> values = <Suspect>[
    SUSPECT_UNKNOWN,
    SUSPECT_COL_MUSTARD,
    SUSPECT_PROF_PLUM,
    SUSPECT_MR_GREEN,
    SUSPECT_MRS_PEACOCK,
    SUSPECT_MISS_SCARLET,
    SUSPECT_MRS_WHITE,
  ];

  static final $core.List<Suspect?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static Suspect? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Suspect._(super.value, super.name);
}

class Weapon extends $pb.ProtobufEnum {
  static const Weapon WEAPON_UNKNOWN =
      Weapon._(0, _omitEnumNames ? '' : 'WEAPON_UNKNOWN');
  static const Weapon WEAPON_KNIFE =
      Weapon._(1, _omitEnumNames ? '' : 'WEAPON_KNIFE');
  static const Weapon WEAPON_CANDLESTICK =
      Weapon._(2, _omitEnumNames ? '' : 'WEAPON_CANDLESTICK');
  static const Weapon WEAPON_REVOLVER =
      Weapon._(3, _omitEnumNames ? '' : 'WEAPON_REVOLVER');
  static const Weapon WEAPON_ROPE =
      Weapon._(4, _omitEnumNames ? '' : 'WEAPON_ROPE');
  static const Weapon WEAPON_LEAD_PIPE =
      Weapon._(5, _omitEnumNames ? '' : 'WEAPON_LEAD_PIPE');
  static const Weapon WEAPON_WRENCH =
      Weapon._(6, _omitEnumNames ? '' : 'WEAPON_WRENCH');

  static const $core.List<Weapon> values = <Weapon>[
    WEAPON_UNKNOWN,
    WEAPON_KNIFE,
    WEAPON_CANDLESTICK,
    WEAPON_REVOLVER,
    WEAPON_ROPE,
    WEAPON_LEAD_PIPE,
    WEAPON_WRENCH,
  ];

  static final $core.List<Weapon?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static Weapon? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Weapon._(super.value, super.name);
}

class Room extends $pb.ProtobufEnum {
  static const Room ROOM_UNKNOWN =
      Room._(0, _omitEnumNames ? '' : 'ROOM_UNKNOWN');
  static const Room ROOM_HALL = Room._(1, _omitEnumNames ? '' : 'ROOM_HALL');
  static const Room ROOM_LOUNGE =
      Room._(2, _omitEnumNames ? '' : 'ROOM_LOUNGE');
  static const Room ROOM_DINING_ROOM =
      Room._(3, _omitEnumNames ? '' : 'ROOM_DINING_ROOM');
  static const Room ROOM_KITCHEN =
      Room._(4, _omitEnumNames ? '' : 'ROOM_KITCHEN');
  static const Room ROOM_BALLROOM =
      Room._(5, _omitEnumNames ? '' : 'ROOM_BALLROOM');
  static const Room ROOM_CONSERVATORY =
      Room._(6, _omitEnumNames ? '' : 'ROOM_CONSERVATORY');
  static const Room ROOM_BILLIARD_ROOM =
      Room._(7, _omitEnumNames ? '' : 'ROOM_BILLIARD_ROOM');
  static const Room ROOM_LIBRARY =
      Room._(8, _omitEnumNames ? '' : 'ROOM_LIBRARY');
  static const Room ROOM_STUDY = Room._(9, _omitEnumNames ? '' : 'ROOM_STUDY');

  static const $core.List<Room> values = <Room>[
    ROOM_UNKNOWN,
    ROOM_HALL,
    ROOM_LOUNGE,
    ROOM_DINING_ROOM,
    ROOM_KITCHEN,
    ROOM_BALLROOM,
    ROOM_CONSERVATORY,
    ROOM_BILLIARD_ROOM,
    ROOM_LIBRARY,
    ROOM_STUDY,
  ];

  static final $core.List<Room?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static Room? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Room._(super.value, super.name);
}

class CellState_Status extends $pb.ProtobufEnum {
  static const CellState_Status UNKNOWN =
      CellState_Status._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const CellState_Status HAS =
      CellState_Status._(1, _omitEnumNames ? '' : 'HAS');
  static const CellState_Status DOES_NOT_HAVE =
      CellState_Status._(2, _omitEnumNames ? '' : 'DOES_NOT_HAVE');
  static const CellState_Status MIGHT_HAVE =
      CellState_Status._(3, _omitEnumNames ? '' : 'MIGHT_HAVE');

  static const $core.List<CellState_Status> values = <CellState_Status>[
    UNKNOWN,
    HAS,
    DOES_NOT_HAVE,
    MIGHT_HAVE,
  ];

  static final $core.List<CellState_Status?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CellState_Status? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CellState_Status._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
