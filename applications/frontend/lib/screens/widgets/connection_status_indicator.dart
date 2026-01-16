import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/game_state.dart';

class ConnectionStatusIndicator extends StatelessWidget {
  const ConnectionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select<GameState, BackendStatus>((state) => state.connectionStatus);

    Color color;
    String message;

    switch (status) {
      case BackendStatus.connected:
        color = Colors.green;
        message = 'Connected';
        break;
      case BackendStatus.disconnected:
        color = Colors.red;
        message = 'Disconnected - Retrying...';
        break;
      case BackendStatus.restoring:
        color = Colors.orange;
        message = 'Restoring Game Session...';
        break;
    }

    return Tooltip(
      message: message,
      child: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
             BoxShadow(
              color: color.withAlpha(128),
              blurRadius: 4,
              spreadRadius: 2,
             ),
          ],
        ),
      ),
    );
  }
}
