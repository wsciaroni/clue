import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../state/game_state.dart';
import 'turn_form.dart';

class EditTurnScreen extends StatelessWidget {
  final int turnIndex;
  final GameTurn initialTurn;

  const EditTurnScreen({
    super.key,
    required this.turnIndex,
    required this.initialTurn,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final players = gameState.players;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Turn')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: TurnForm(
          players: players,
          initialTurn: initialTurn,
          submitLabel: 'Update Turn',
          clearOnSubmit: false,
          onSubmit: (updatedTurn) {
            context.read<GameState>().updateTurn(turnIndex, updatedTurn);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Turn Updated')),
            );
          },
        ),
      ),
    );
  }
}
