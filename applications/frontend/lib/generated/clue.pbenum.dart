///
//  Generated code. Do not modify.
//  source: clue.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name,dangling_library_doc_comments

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class CardType extends $pb.ProtobufEnum {
  static const CardType CARD_TYPE_UNKNOWN = CardType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CARD_TYPE_UNKNOWN');
  static const CardType CARD_TYPE_SUSPECT = CardType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CARD_TYPE_SUSPECT');
  static const CardType CARD_TYPE_WEAPON = CardType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CARD_TYPE_WEAPON');
  static const CardType CARD_TYPE_ROOM = CardType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CARD_TYPE_ROOM');

  static const $core.List<CardType> values = <CardType> [
    CARD_TYPE_UNKNOWN,
    CARD_TYPE_SUSPECT,
    CARD_TYPE_WEAPON,
    CARD_TYPE_ROOM,
  ];

  static final $core.Map<$core.int, CardType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CardType? valueOf($core.int value) => _byValue[value];

  const CardType._($core.int v, $core.String n) : super(v, n);
}

class Suspect extends $pb.ProtobufEnum {
  static const Suspect SUSPECT_UNKNOWN = Suspect._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUSPECT_UNKNOWN');
  static const Suspect SUSPECT_COL_MUSTARD = Suspect._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUSPECT_COL_MUSTARD');
  static const Suspect SUSPECT_PROF_PLUM = Suspect._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUSPECT_PROF_PLUM');
  static const Suspect SUSPECT_MR_GREEN = Suspect._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUSPECT_MR_GREEN');
  static const Suspect SUSPECT_MRS_PEACOCK = Suspect._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUSPECT_MRS_PEACOCK');
  static const Suspect SUSPECT_MISS_SCARLET = Suspect._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUSPECT_MISS_SCARLET');
  static const Suspect SUSPECT_MRS_WHITE = Suspect._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUSPECT_MRS_WHITE');

  static const $core.List<Suspect> values = <Suspect> [
    SUSPECT_UNKNOWN,
    SUSPECT_COL_MUSTARD,
    SUSPECT_PROF_PLUM,
    SUSPECT_MR_GREEN,
    SUSPECT_MRS_PEACOCK,
    SUSPECT_MISS_SCARLET,
    SUSPECT_MRS_WHITE,
  ];

  static final $core.Map<$core.int, Suspect> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Suspect? valueOf($core.int value) => _byValue[value];

  const Suspect._($core.int v, $core.String n) : super(v, n);
}

class Weapon extends $pb.ProtobufEnum {
  static const Weapon WEAPON_UNKNOWN = Weapon._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WEAPON_UNKNOWN');
  static const Weapon WEAPON_KNIFE = Weapon._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WEAPON_KNIFE');
  static const Weapon WEAPON_CANDLESTICK = Weapon._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WEAPON_CANDLESTICK');
  static const Weapon WEAPON_REVOLVER = Weapon._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WEAPON_REVOLVER');
  static const Weapon WEAPON_ROPE = Weapon._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WEAPON_ROPE');
  static const Weapon WEAPON_LEAD_PIPE = Weapon._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WEAPON_LEAD_PIPE');
  static const Weapon WEAPON_WRENCH = Weapon._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WEAPON_WRENCH');

  static const $core.List<Weapon> values = <Weapon> [
    WEAPON_UNKNOWN,
    WEAPON_KNIFE,
    WEAPON_CANDLESTICK,
    WEAPON_REVOLVER,
    WEAPON_ROPE,
    WEAPON_LEAD_PIPE,
    WEAPON_WRENCH,
  ];

  static final $core.Map<$core.int, Weapon> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Weapon? valueOf($core.int value) => _byValue[value];

  const Weapon._($core.int v, $core.String n) : super(v, n);
}

class Room extends $pb.ProtobufEnum {
  static const Room ROOM_UNKNOWN = Room._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_UNKNOWN');
  static const Room ROOM_HALL = Room._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_HALL');
  static const Room ROOM_LOUNGE = Room._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_LOUNGE');
  static const Room ROOM_DINING_ROOM = Room._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_DINING_ROOM');
  static const Room ROOM_KITCHEN = Room._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_KITCHEN');
  static const Room ROOM_BALLROOM = Room._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_BALLROOM');
  static const Room ROOM_CONSERVATORY = Room._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_CONSERVATORY');
  static const Room ROOM_BILLIARD_ROOM = Room._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_BILLIARD_ROOM');
  static const Room ROOM_LIBRARY = Room._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_LIBRARY');
  static const Room ROOM_STUDY = Room._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROOM_STUDY');

  static const $core.List<Room> values = <Room> [
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

  static final $core.Map<$core.int, Room> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Room? valueOf($core.int value) => _byValue[value];

  const Room._($core.int v, $core.String n) : super(v, n);
}

class DeductionStatus extends $pb.ProtobufEnum {
  static const DeductionStatus UNKNOWN = DeductionStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNKNOWN');
  static const DeductionStatus HAS_IT = DeductionStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HAS_IT');
  static const DeductionStatus DOES_NOT_HAVE_IT = DeductionStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DOES_NOT_HAVE_IT');
  static const DeductionStatus MIGHT_HAVE_IT = DeductionStatus._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MIGHT_HAVE_IT');

  static const $core.List<DeductionStatus> values = <DeductionStatus> [
    UNKNOWN,
    HAS_IT,
    DOES_NOT_HAVE_IT,
    MIGHT_HAVE_IT,
  ];

  static final $core.Map<$core.int, DeductionStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeductionStatus? valueOf($core.int value) => _byValue[value];

  const DeductionStatus._($core.int v, $core.String n) : super(v, n);
}
