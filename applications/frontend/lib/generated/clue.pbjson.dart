// This is a generated file - do not edit.
//
// Generated from clue.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use deductionStatusDescriptor instead')
const DeductionStatus$json = {
  '1': 'DeductionStatus',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'HAS_IT', '2': 1},
    {'1': 'DOES_NOT_HAVE_IT', '2': 2},
    {'1': 'MIGHT_HAVE_IT', '2': 3},
  ],
};

/// Descriptor for `DeductionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deductionStatusDescriptor = $convert.base64Decode(
    'Cg9EZWR1Y3Rpb25TdGF0dXMSCwoHVU5LTk9XThAAEgoKBkhBU19JVBABEhQKEERPRVNfTk9UX0'
    'hBVkVfSVQQAhIRCg1NSUdIVF9IQVZFX0lUEAM=');

@$core.Deprecated('Use cardTypeDescriptor instead')
const CardType$json = {
  '1': 'CardType',
  '2': [
    {'1': 'CARD_TYPE_UNKNOWN', '2': 0},
    {'1': 'CARD_TYPE_SUSPECT', '2': 1},
    {'1': 'CARD_TYPE_WEAPON', '2': 2},
    {'1': 'CARD_TYPE_ROOM', '2': 3},
  ],
};

/// Descriptor for `CardType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cardTypeDescriptor = $convert.base64Decode(
    'CghDYXJkVHlwZRIVChFDQVJEX1RZUEVfVU5LTk9XThAAEhUKEUNBUkRfVFlQRV9TVVNQRUNUEA'
    'ESFAoQQ0FSRF9UWVBFX1dFQVBPThACEhIKDkNBUkRfVFlQRV9ST09NEAM=');

@$core.Deprecated('Use suspectDescriptor instead')
const Suspect$json = {
  '1': 'Suspect',
  '2': [
    {'1': 'SUSPECT_UNKNOWN', '2': 0},
    {'1': 'SUSPECT_COL_MUSTARD', '2': 1},
    {'1': 'SUSPECT_PROF_PLUM', '2': 2},
    {'1': 'SUSPECT_MR_GREEN', '2': 3},
    {'1': 'SUSPECT_MRS_PEACOCK', '2': 4},
    {'1': 'SUSPECT_MISS_SCARLET', '2': 5},
    {'1': 'SUSPECT_MRS_WHITE', '2': 6},
  ],
};

/// Descriptor for `Suspect`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List suspectDescriptor = $convert.base64Decode(
    'CgdTdXNwZWN0EhMKD1NVU1BFQ1RfVU5LTk9XThAAEhcKE1NVU1BFQ1RfQ09MX01VU1RBUkQQAR'
    'IVChFTVVNQRUNUX1BST0ZfUExVTRACEhQKEFNVU1BFQ1RfTVJfR1JFRU4QAxIXChNTVVNQRUNU'
    'X01SU19QRUFDT0NLEAQSGAoUU1VTUEVDVF9NSVNTX1NDQVJMRVQQBRIVChFTVVNQRUNUX01SU1'
    '9XSElURRAG');

@$core.Deprecated('Use weaponDescriptor instead')
const Weapon$json = {
  '1': 'Weapon',
  '2': [
    {'1': 'WEAPON_UNKNOWN', '2': 0},
    {'1': 'WEAPON_KNIFE', '2': 1},
    {'1': 'WEAPON_CANDLESTICK', '2': 2},
    {'1': 'WEAPON_REVOLVER', '2': 3},
    {'1': 'WEAPON_ROPE', '2': 4},
    {'1': 'WEAPON_LEAD_PIPE', '2': 5},
    {'1': 'WEAPON_WRENCH', '2': 6},
  ],
};

/// Descriptor for `Weapon`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List weaponDescriptor = $convert.base64Decode(
    'CgZXZWFwb24SEgoOV0VBUE9OX1VOS05PV04QABIQCgxXRUFQT05fS05JRkUQARIWChJXRUFQT0'
    '5fQ0FORExFU1RJQ0sQAhITCg9XRUFQT05fUkVWT0xWRVIQAxIPCgtXRUFQT05fUk9QRRAEEhQK'
    'EFdFQVBPTl9MRUFEX1BJUEUQBRIRCg1XRUFQT05fV1JFTkNIEAY=');

@$core.Deprecated('Use roomDescriptor instead')
const Room$json = {
  '1': 'Room',
  '2': [
    {'1': 'ROOM_UNKNOWN', '2': 0},
    {'1': 'ROOM_HALL', '2': 1},
    {'1': 'ROOM_LOUNGE', '2': 2},
    {'1': 'ROOM_DINING_ROOM', '2': 3},
    {'1': 'ROOM_KITCHEN', '2': 4},
    {'1': 'ROOM_BALLROOM', '2': 5},
    {'1': 'ROOM_CONSERVATORY', '2': 6},
    {'1': 'ROOM_BILLIARD_ROOM', '2': 7},
    {'1': 'ROOM_LIBRARY', '2': 8},
    {'1': 'ROOM_STUDY', '2': 9},
  ],
};

/// Descriptor for `Room`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomDescriptor = $convert.base64Decode(
    'CgRSb29tEhAKDFJPT01fVU5LTk9XThAAEg0KCVJPT01fSEFMTBABEg8KC1JPT01fTE9VTkdFEA'
    'ISFAoQUk9PTV9ESU5JTkdfUk9PTRADEhAKDFJPT01fS0lUQ0hFThAEEhEKDVJPT01fQkFMTFJP'
    'T00QBRIVChFST09NX0NPTlNFUlZBVE9SWRAGEhYKElJPT01fQklMTElBUkRfUk9PTRAHEhAKDF'
    'JPT01fTElCUkFSWRAIEg4KClJPT01fU1RVRFkQCQ==');

@$core.Deprecated('Use gameStatusRequestDescriptor instead')
const GameStatusRequest$json = {
  '1': 'GameStatusRequest',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `GameStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStatusRequestDescriptor = $convert.base64Decode(
    'ChFHYW1lU3RhdHVzUmVxdWVzdBIXCgdnYW1lX2lkGAEgASgJUgZnYW1lSWQ=');

@$core.Deprecated('Use gameStatusResponseDescriptor instead')
const GameStatusResponse$json = {
  '1': 'GameStatusResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
    {'1': 'is_active', '3': 2, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `GameStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStatusResponseDescriptor = $convert.base64Decode(
    'ChJHYW1lU3RhdHVzUmVzcG9uc2USFgoGc3RhdHVzGAEgASgJUgZzdGF0dXMSGwoJaXNfYWN0aX'
    'ZlGAIgASgIUghpc0FjdGl2ZQ==');

@$core.Deprecated('Use initGameRequestDescriptor instead')
const InitGameRequest$json = {
  '1': 'InitGameRequest',
  '2': [
    {'1': 'num_players', '3': 1, '4': 1, '5': 5, '10': 'numPlayers'},
    {'1': 'player_names', '3': 2, '4': 3, '5': 9, '10': 'playerNames'},
    {
      '1': 'my_cards',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.clue.Card',
      '10': 'myCards'
    },
  ],
};

/// Descriptor for `InitGameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initGameRequestDescriptor = $convert.base64Decode(
    'Cg9Jbml0R2FtZVJlcXVlc3QSHwoLbnVtX3BsYXllcnMYASABKAVSCm51bVBsYXllcnMSIQoMcG'
    'xheWVyX25hbWVzGAIgAygJUgtwbGF5ZXJOYW1lcxIlCghteV9jYXJkcxgDIAMoCzIKLmNsdWUu'
    'Q2FyZFIHbXlDYXJkcw==');

@$core.Deprecated('Use initGameResponseDescriptor instead')
const InitGameResponse$json = {
  '1': 'InitGameResponse',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error_message', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `InitGameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initGameResponseDescriptor = $convert.base64Decode(
    'ChBJbml0R2FtZVJlc3BvbnNlEhcKB2dhbWVfaWQYASABKAlSBmdhbWVJZBIYCgdzdWNjZXNzGA'
    'IgASgIUgdzdWNjZXNzEiMKDWVycm9yX21lc3NhZ2UYAyABKAlSDGVycm9yTWVzc2FnZQ==');

@$core.Deprecated('Use turnRequestDescriptor instead')
const TurnRequest$json = {
  '1': 'TurnRequest',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'suggester', '3': 2, '4': 1, '5': 9, '10': 'suggester'},
    {
      '1': 'suggestion_suspect',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.clue.Card',
      '10': 'suggestionSuspect'
    },
    {
      '1': 'suggestion_weapon',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.clue.Card',
      '10': 'suggestionWeapon'
    },
    {
      '1': 'suggestion_room',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.clue.Card',
      '10': 'suggestionRoom'
    },
    {'1': 'responder', '3': 6, '4': 1, '5': 9, '10': 'responder'},
    {'1': 'card_shown', '3': 7, '4': 1, '5': 8, '10': 'cardShown'},
    {
      '1': 'shown_card',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.clue.Card',
      '10': 'shownCard'
    },
  ],
};

/// Descriptor for `TurnRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnRequestDescriptor = $convert.base64Decode(
    'CgtUdXJuUmVxdWVzdBIXCgdnYW1lX2lkGAEgASgJUgZnYW1lSWQSHAoJc3VnZ2VzdGVyGAIgAS'
    'gJUglzdWdnZXN0ZXISOQoSc3VnZ2VzdGlvbl9zdXNwZWN0GAMgASgLMgouY2x1ZS5DYXJkUhFz'
    'dWdnZXN0aW9uU3VzcGVjdBI3ChFzdWdnZXN0aW9uX3dlYXBvbhgEIAEoCzIKLmNsdWUuQ2FyZF'
    'IQc3VnZ2VzdGlvbldlYXBvbhIzCg9zdWdnZXN0aW9uX3Jvb20YBSABKAsyCi5jbHVlLkNhcmRS'
    'DnN1Z2dlc3Rpb25Sb29tEhwKCXJlc3BvbmRlchgGIAEoCVIJcmVzcG9uZGVyEh0KCmNhcmRfc2'
    'hvd24YByABKAhSCWNhcmRTaG93bhIpCgpzaG93bl9jYXJkGAggASgLMgouY2x1ZS5DYXJkUglz'
    'aG93bkNhcmQ=');

@$core.Deprecated('Use turnResponseDescriptor instead')
const TurnResponse$json = {
  '1': 'TurnResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `TurnResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnResponseDescriptor = $convert.base64Decode(
    'CgxUdXJuUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIjCg1lcnJvcl9tZXNzYW'
    'dlGAIgASgJUgxlcnJvck1lc3NhZ2U=');

@$core.Deprecated('Use deductionRequestDescriptor instead')
const DeductionRequest$json = {
  '1': 'DeductionRequest',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `DeductionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deductionRequestDescriptor = $convert.base64Decode(
    'ChBEZWR1Y3Rpb25SZXF1ZXN0EhcKB2dhbWVfaWQYASABKAlSBmdhbWVJZA==');

@$core.Deprecated('Use deductionResponseDescriptor instead')
const DeductionResponse$json = {
  '1': 'DeductionResponse',
  '2': [
    {
      '1': 'knowledge',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.clue.CardKnowledge',
      '10': 'knowledge'
    },
  ],
};

/// Descriptor for `DeductionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deductionResponseDescriptor = $convert.base64Decode(
    'ChFEZWR1Y3Rpb25SZXNwb25zZRIxCglrbm93bGVkZ2UYASADKAsyEy5jbHVlLkNhcmRLbm93bG'
    'VkZ2VSCWtub3dsZWRnZQ==');

@$core.Deprecated('Use cardKnowledgeDescriptor instead')
const CardKnowledge$json = {
  '1': 'CardKnowledge',
  '2': [
    {'1': 'player_name', '3': 1, '4': 1, '5': 9, '10': 'playerName'},
    {'1': 'card', '3': 2, '4': 1, '5': 11, '6': '.clue.Card', '10': 'card'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.clue.DeductionStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `CardKnowledge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardKnowledgeDescriptor = $convert.base64Decode(
    'Cg1DYXJkS25vd2xlZGdlEh8KC3BsYXllcl9uYW1lGAEgASgJUgpwbGF5ZXJOYW1lEh4KBGNhcm'
    'QYAiABKAsyCi5jbHVlLkNhcmRSBGNhcmQSLQoGc3RhdHVzGAMgASgOMhUuY2x1ZS5EZWR1Y3Rp'
    'b25TdGF0dXNSBnN0YXR1cw==');

@$core.Deprecated('Use cardDescriptor instead')
const Card$json = {
  '1': 'Card',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.clue.CardType', '10': 'type'},
    {
      '1': 'suspect',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.clue.Suspect',
      '10': 'suspect'
    },
    {
      '1': 'weapon',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.clue.Weapon',
      '10': 'weapon'
    },
    {'1': 'room', '3': 5, '4': 1, '5': 14, '6': '.clue.Room', '10': 'room'},
  ],
};

/// Descriptor for `Card`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardDescriptor = $convert.base64Decode(
    'CgRDYXJkEhIKBG5hbWUYASABKAlSBG5hbWUSIgoEdHlwZRgCIAEoDjIOLmNsdWUuQ2FyZFR5cG'
    'VSBHR5cGUSJwoHc3VzcGVjdBgDIAEoDjINLmNsdWUuU3VzcGVjdFIHc3VzcGVjdBIkCgZ3ZWFw'
    'b24YBCABKA4yDC5jbHVlLldlYXBvblIGd2VhcG9uEh4KBHJvb20YBSABKA4yCi5jbHVlLlJvb2'
    '1SBHJvb20=');
