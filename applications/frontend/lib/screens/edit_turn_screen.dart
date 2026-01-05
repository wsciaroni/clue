import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import 'turn_form.dart';

class EditTurnScreen extends StatelessWidget {
  final GameTurn turn;

  const EditTurnScreen({super.key, required this.turn});

  @override
  Widget build(BuildContext context) {
    final gameState = context.read<GameState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Turn'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: TurnForm(
          players: gameState.players,
          initialTurn: turn,
          onSubmit: (updatedTurn) {
            gameState.updateTurn(updatedTurn);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Turn Updated')),
            );
          },
        ),
      ),
    );
  }
}
