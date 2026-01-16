import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A workaround for a Flutter Windows regression where accessibility announcements
/// fail if `viewId` is missing.
///
/// See: https://github.com/flutter/flutter/issues/179563
class AccessibilityFixBinding extends WidgetsFlutterBinding {
  static void ensureInitialized() {
    AccessibilityFixBinding();
  }

  @override
  BinaryMessenger createBinaryMessenger() {
    return _AccessibilityFixMessenger(super.createBinaryMessenger());
  }
}

class _AccessibilityFixMessenger extends BinaryMessenger {
  final BinaryMessenger _delegate;

  _AccessibilityFixMessenger(this._delegate);

  @override
  Future<ByteData?>? send(String channel, ByteData? message) {
    if (channel == 'flutter/accessibility' &&
        defaultTargetPlatform == TargetPlatform.windows) {
      if (message != null) {
        try {
          final dynamic decoded =
              const StandardMessageCodec().decodeMessage(message);
          if (decoded is Map) {
            final Map<dynamic, dynamic> map = decoded;
            if (map['type'] == 'announce' && !map.containsKey('viewId')) {
              final Map<dynamic, dynamic> newMap =
                  Map<dynamic, dynamic>.from(map);
              newMap['viewId'] = 0;

              final ByteData? newMessage =
                  const StandardMessageCodec().encodeMessage(newMap);
              return _delegate.send(channel, newMessage);
            }
          }
        } catch (e) {
          debugPrint('Error intercepting accessibility message: $e');
        }
      }
    }
    return _delegate.send(channel, message);
  }

  @override
  // ignore: deprecated_member_use
  Future<void> handlePlatformMessage(String channel, ByteData? data,
      PlatformMessageResponseCallback? callback) {
    // ignore: deprecated_member_use
    return _delegate.handlePlatformMessage(channel, data, callback);
  }

  @override
  void setMessageHandler(String channel, MessageHandler? handler) {
    _delegate.setMessageHandler(channel, handler);
  }
}
