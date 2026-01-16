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
          final MethodCall call =
              const StandardMethodCodec().decodeMethodCall(message);
          if (call.method == 'announce') {
            final dynamic args = call.arguments;
            if (args is Map) {
              final Map<dynamic, dynamic> argsMap = args;
              if (!argsMap.containsKey('viewId')) {
                // Clone and add viewId: 0 (implicit view)
                // We cast to Map<String, dynamic> because StandardMethodCodec usually produces valid keys,
                // and 'announce' arguments are known keys.
                // However, let's be safe and copy to a new map.
                final Map<String, dynamic> newArgs =
                    Map<String, dynamic>.from(argsMap.cast<String, dynamic>());
                newArgs['viewId'] = 0;

                final ByteData newMessage = const StandardMethodCodec()
                    .encodeMethodCall(MethodCall(call.method, newArgs));
                return _delegate.send(channel, newMessage);
              }
            }
          }
        } catch (e) {
          // Fallback to original message if decoding fails
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
