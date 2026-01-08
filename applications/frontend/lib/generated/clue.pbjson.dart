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

@$core.Deprecated('Use cardDescriptor instead')
const Card$json = {
  '1': 'Card',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.clue.CardType', '10': 'type'},
    {
      '1': 'suspect',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.clue.Suspect',
      '9': 0,
      '10': 'suspect'
    },
    {
      '1': 'weapon',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.clue.Weapon',
      '9': 0,
      '10': 'weapon'
    },
    {
      '1': 'room',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.clue.Room',
      '9': 0,
      '10': 'room'
    },
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `Card`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardDescriptor = $convert.base64Decode(
    'CgRDYXJkEiIKBHR5cGUYASABKA4yDi5jbHVlLkNhcmRUeXBlUgR0eXBlEikKB3N1c3BlY3QYAi'
    'ABKA4yDS5jbHVlLlN1c3BlY3RIAFIHc3VzcGVjdBImCgZ3ZWFwb24YAyABKA4yDC5jbHVlLldl'
    'YXBvbkgAUgZ3ZWFwb24SIAoEcm9vbRgEIAEoDjIKLmNsdWUuUm9vbUgAUgRyb29tQgcKBXZhbH'
    'Vl');

@$core.Deprecated('Use turnDataDescriptor instead')
const TurnData$json = {
  '1': 'TurnData',
  '2': [
    {
      '1': 'suggester_player_index',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'suggesterPlayerIndex'
    },
    {
      '1': 'suspect',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.clue.Card',
      '10': 'suspect'
    },
    {'1': 'weapon', '3': 3, '4': 1, '5': 11, '6': '.clue.Card', '10': 'weapon'},
    {'1': 'room', '3': 4, '4': 1, '5': 11, '6': '.clue.Card', '10': 'room'},
    {
      '1': 'responder_player_index',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'responderPlayerIndex'
    },
    {
      '1': 'card_shown',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.clue.Card',
      '9': 0,
      '10': 'cardShown',
      '17': true
    },
    {'1': 'is_accusation', '3': 7, '4': 1, '5': 8, '10': 'isAccusation'},
    {'1': 'was_correct', '3': 8, '4': 1, '5': 8, '10': 'wasCorrect'},
  ],
  '8': [
    {'1': '_card_shown'},
  ],
};

/// Descriptor for `TurnData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnDataDescriptor = $convert.base64Decode(
    'CghUdXJuRGF0YRI0ChZzdWdnZXN0ZXJfcGxheWVyX2luZGV4GAEgASgFUhRzdWdnZXN0ZXJQbG'
    'F5ZXJJbmRleBIkCgdzdXNwZWN0GAIgASgLMgouY2x1ZS5DYXJkUgdzdXNwZWN0EiIKBndlYXBv'
    'bhgDIAEoCzIKLmNsdWUuQ2FyZFIGd2VhcG9uEh4KBHJvb20YBCABKAsyCi5jbHVlLkNhcmRSBH'
    'Jvb20SNAoWcmVzcG9uZGVyX3BsYXllcl9pbmRleBgFIAEoBVIUcmVzcG9uZGVyUGxheWVySW5k'
    'ZXgSLgoKY2FyZF9zaG93bhgGIAEoCzIKLmNsdWUuQ2FyZEgAUgljYXJkU2hvd26IAQESIwoNaX'
    'NfYWNjdXNhdGlvbhgHIAEoCFIMaXNBY2N1c2F0aW9uEh8KC3dhc19jb3JyZWN0GAggASgIUgp3'
    'YXNDb3JyZWN0Qg0KC19jYXJkX3Nob3du');

@$core.Deprecated('Use turnEntryDescriptor instead')
const TurnEntry$json = {
  '1': 'TurnEntry',
  '2': [
    {'1': 'turn_id', '3': 1, '4': 1, '5': 9, '10': 'turnId'},
    {'1': 'turn_number', '3': 2, '4': 1, '5': 5, '10': 'turnNumber'},
    {'1': 'data', '3': 3, '4': 1, '5': 11, '6': '.clue.TurnData', '10': 'data'},
  ],
};

/// Descriptor for `TurnEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnEntryDescriptor = $convert.base64Decode(
    'CglUdXJuRW50cnkSFwoHdHVybl9pZBgBIAEoCVIGdHVybklkEh8KC3R1cm5fbnVtYmVyGAIgAS'
    'gFUgp0dXJuTnVtYmVyEiIKBGRhdGEYAyABKAsyDi5jbHVlLlR1cm5EYXRhUgRkYXRh');

@$core.Deprecated('Use playerInfoDescriptor instead')
const PlayerInfo$json = {
  '1': 'PlayerInfo',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 5, '10': 'index'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'card_count', '3': 3, '4': 1, '5': 5, '10': 'cardCount'},
  ],
};

/// Descriptor for `PlayerInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerInfoDescriptor = $convert.base64Decode(
    'CgpQbGF5ZXJJbmZvEhQKBWluZGV4GAEgASgFUgVpbmRleBISCgRuYW1lGAIgASgJUgRuYW1lEh'
    '0KCmNhcmRfY291bnQYAyABKAVSCWNhcmRDb3VudA==');

@$core.Deprecated('Use cellStateDescriptor instead')
const CellState$json = {
  '1': 'CellState',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.clue.CellState.Status',
      '10': 'status'
    },
  ],
  '4': [CellState_Status$json],
};

@$core.Deprecated('Use cellStateDescriptor instead')
const CellState_Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'HAS', '2': 1},
    {'1': 'DOES_NOT_HAVE', '2': 2},
    {'1': 'MIGHT_HAVE', '2': 3},
  ],
};

/// Descriptor for `CellState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cellStateDescriptor = $convert.base64Decode(
    'CglDZWxsU3RhdGUSLgoGc3RhdHVzGAEgASgOMhYuY2x1ZS5DZWxsU3RhdGUuU3RhdHVzUgZzdG'
    'F0dXMiQQoGU3RhdHVzEgsKB1VOS05PV04QABIHCgNIQVMQARIRCg1ET0VTX05PVF9IQVZFEAIS'
    'DgoKTUlHSFRfSEFWRRAD');

@$core.Deprecated('Use gridRowDescriptor instead')
const GridRow$json = {
  '1': 'GridRow',
  '2': [
    {'1': 'card', '3': 1, '4': 1, '5': 11, '6': '.clue.Card', '10': 'card'},
    {
      '1': 'player_states',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.clue.CellState',
      '10': 'playerStates'
    },
  ],
};

/// Descriptor for `GridRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gridRowDescriptor = $convert.base64Decode(
    'CgdHcmlkUm93Eh4KBGNhcmQYASABKAsyCi5jbHVlLkNhcmRSBGNhcmQSNAoNcGxheWVyX3N0YX'
    'RlcxgCIAMoCzIPLmNsdWUuQ2VsbFN0YXRlUgxwbGF5ZXJTdGF0ZXM=');

@$core.Deprecated('Use solutionProbabilityDescriptor instead')
const SolutionProbability$json = {
  '1': 'SolutionProbability',
  '2': [
    {'1': 'card', '3': 1, '4': 1, '5': 11, '6': '.clue.Card', '10': 'card'},
    {'1': 'probability', '3': 2, '4': 1, '5': 2, '10': 'probability'},
    {'1': 'is_eliminated', '3': 3, '4': 1, '5': 8, '10': 'isEliminated'},
  ],
};

/// Descriptor for `SolutionProbability`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solutionProbabilityDescriptor = $convert.base64Decode(
    'ChNTb2x1dGlvblByb2JhYmlsaXR5Eh4KBGNhcmQYASABKAsyCi5jbHVlLkNhcmRSBGNhcmQSIA'
    'oLcHJvYmFiaWxpdHkYAiABKAJSC3Byb2JhYmlsaXR5EiMKDWlzX2VsaW1pbmF0ZWQYAyABKAhS'
    'DGlzRWxpbWluYXRlZA==');

@$core.Deprecated('Use initGameRequestDescriptor instead')
const InitGameRequest$json = {
  '1': 'InitGameRequest',
  '2': [
    {'1': 'num_players', '3': 1, '4': 1, '5': 5, '10': 'numPlayers'},
    {'1': 'player_names', '3': 2, '4': 3, '5': 9, '10': 'playerNames'},
    {
      '1': 'my_hand',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.clue.Card',
      '10': 'myHand'
    },
  ],
};

/// Descriptor for `InitGameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initGameRequestDescriptor = $convert.base64Decode(
    'Cg9Jbml0R2FtZVJlcXVlc3QSHwoLbnVtX3BsYXllcnMYASABKAVSCm51bVBsYXllcnMSIQoMcG'
    'xheWVyX25hbWVzGAIgAygJUgtwbGF5ZXJOYW1lcxIjCgdteV9oYW5kGAMgAygLMgouY2x1ZS5D'
    'YXJkUgZteUhhbmQ=');

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
    {'1': 'data', '3': 2, '4': 1, '5': 11, '6': '.clue.TurnData', '10': 'data'},
  ],
};

/// Descriptor for `TurnRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnRequestDescriptor = $convert.base64Decode(
    'CgtUdXJuUmVxdWVzdBIXCgdnYW1lX2lkGAEgASgJUgZnYW1lSWQSIgoEZGF0YRgCIAEoCzIOLm'
    'NsdWUuVHVybkRhdGFSBGRhdGE=');

@$core.Deprecated('Use updateTurnRequestDescriptor instead')
const UpdateTurnRequest$json = {
  '1': 'UpdateTurnRequest',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'turn_id', '3': 2, '4': 1, '5': 9, '10': 'turnId'},
    {
      '1': 'new_data',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.clue.TurnData',
      '10': 'newData'
    },
  ],
};

/// Descriptor for `UpdateTurnRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTurnRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVUdXJuUmVxdWVzdBIXCgdnYW1lX2lkGAEgASgJUgZnYW1lSWQSFwoHdHVybl9pZB'
    'gCIAEoCVIGdHVybklkEikKCG5ld19kYXRhGAMgASgLMg4uY2x1ZS5UdXJuRGF0YVIHbmV3RGF0'
    'YQ==');

@$core.Deprecated('Use deleteTurnRequestDescriptor instead')
const DeleteTurnRequest$json = {
  '1': 'DeleteTurnRequest',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'turn_id', '3': 2, '4': 1, '5': 9, '10': 'turnId'},
  ],
};

/// Descriptor for `DeleteTurnRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTurnRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVUdXJuUmVxdWVzdBIXCgdnYW1lX2lkGAEgASgJUgZnYW1lSWQSFwoHdHVybl9pZB'
    'gCIAEoCVIGdHVybklk');

@$core.Deprecated('Use deleteTurnResponseDescriptor instead')
const DeleteTurnResponse$json = {
  '1': 'DeleteTurnResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `DeleteTurnResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTurnResponseDescriptor = $convert.base64Decode(
    'ChJEZWxldGVUdXJuUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIjCg1lcnJvcl'
    '9tZXNzYWdlGAIgASgJUgxlcnJvck1lc3NhZ2U=');

@$core.Deprecated('Use turnResponseDescriptor instead')
const TurnResponse$json = {
  '1': 'TurnResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'turn_id', '3': 3, '4': 1, '5': 9, '10': 'turnId'},
  ],
};

/// Descriptor for `TurnResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnResponseDescriptor = $convert.base64Decode(
    'CgxUdXJuUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIjCg1lcnJvcl9tZXNzYW'
    'dlGAIgASgJUgxlcnJvck1lc3NhZ2USFwoHdHVybl9pZBgDIAEoCVIGdHVybklk');

@$core.Deprecated('Use undoRequestDescriptor instead')
const UndoRequest$json = {
  '1': 'UndoRequest',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `UndoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List undoRequestDescriptor = $convert
    .base64Decode('CgtVbmRvUmVxdWVzdBIXCgdnYW1lX2lkGAEgASgJUgZnYW1lSWQ=');

@$core.Deprecated('Use undoResponseDescriptor instead')
const UndoResponse$json = {
  '1': 'UndoResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UndoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List undoResponseDescriptor = $convert
    .base64Decode('CgxVbmRvUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use getHistoryRequestDescriptor instead')
const GetHistoryRequest$json = {
  '1': 'GetHistoryRequest',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `GetHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHistoryRequestDescriptor = $convert.base64Decode(
    'ChFHZXRIaXN0b3J5UmVxdWVzdBIXCgdnYW1lX2lkGAEgASgJUgZnYW1lSWQ=');

@$core.Deprecated('Use getHistoryResponseDescriptor instead')
const GetHistoryResponse$json = {
  '1': 'GetHistoryResponse',
  '2': [
    {
      '1': 'history',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.clue.TurnEntry',
      '10': 'history'
    },
  ],
};

/// Descriptor for `GetHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHistoryResponseDescriptor = $convert.base64Decode(
    'ChJHZXRIaXN0b3J5UmVzcG9uc2USKQoHaGlzdG9yeRgBIAMoCzIPLmNsdWUuVHVybkVudHJ5Ug'
    'doaXN0b3J5');

@$core.Deprecated('Use gameStateRequestDescriptor instead')
const GameStateRequest$json = {
  '1': 'GameStateRequest',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `GameStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStateRequestDescriptor = $convert.base64Decode(
    'ChBHYW1lU3RhdGVSZXF1ZXN0EhcKB2dhbWVfaWQYASABKAlSBmdhbWVJZA==');

@$core.Deprecated('Use gameStateResponseDescriptor instead')
const GameStateResponse$json = {
  '1': 'GameStateResponse',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {
      '1': 'players',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.clue.PlayerInfo',
      '10': 'players'
    },
    {'1': 'rows', '3': 3, '4': 3, '5': 11, '6': '.clue.GridRow', '10': 'rows'},
    {
      '1': 'solution_probabilities',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.clue.SolutionProbability',
      '10': 'solutionProbabilities'
    },
  ],
};

/// Descriptor for `GameStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStateResponseDescriptor = $convert.base64Decode(
    'ChFHYW1lU3RhdGVSZXNwb25zZRIXCgdnYW1lX2lkGAEgASgJUgZnYW1lSWQSKgoHcGxheWVycx'
    'gCIAMoCzIQLmNsdWUuUGxheWVySW5mb1IHcGxheWVycxIhCgRyb3dzGAMgAygLMg0uY2x1ZS5H'
    'cmlkUm93UgRyb3dzElAKFnNvbHV0aW9uX3Byb2JhYmlsaXRpZXMYBCADKAsyGS5jbHVlLlNvbH'
    'V0aW9uUHJvYmFiaWxpdHlSFXNvbHV0aW9uUHJvYmFiaWxpdGllcw==');
