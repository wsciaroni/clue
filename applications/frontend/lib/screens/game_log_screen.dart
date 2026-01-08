import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import 'turn_form.dart';
import 'edit_turn_screen.dart';

class GameLogScreen extends StatelessWidget {
  const GameLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final players = gameState.players;

    return Column(
      children: [
        Expanded(
          flex: 4,
          child: ListView.builder(
            itemCount: gameState.turnLog.length,
            itemBuilder: (context, index) {
              final turn = gameState.turnLog[index];
              return ListTile(
                leading: Text('${gameState.turnLog.length - index}'),
                title: Text(turn.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTurnScreen(turn: turn),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, turn),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const Divider(),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Record Turn',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TurnForm(
                  players: players,
                  onSubmit: (turn) {
                    context.read<GameState>().recordTurn(turn);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Turn Recorded')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, GameTurn turn) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Turn?"),
        content: const Text("Are you sure you want to delete this turn? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<GameState>().deleteTurn(turn);
              ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Turn Deleted')),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
