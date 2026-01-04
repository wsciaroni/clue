import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../state/game_state.dart';
import 'turn_form.dart';
import 'edit_turn_screen.dart';

class GameLogScreen extends StatefulWidget {
  const GameLogScreen({super.key});

  @override
  State<GameLogScreen> createState() => _GameLogScreenState();
}

class _GameLogScreenState extends State<GameLogScreen> {
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
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Edit Turn?'),
                      content: const Text('Would you like to edit this turn?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTurnScreen(
                                  turnIndex: index,
                                  initialTurn: turn,
                                ),
                              ),
                            );
                          },
                          child: const Text('Edit'),
                        ),
                      ],
                    ),
                  );
                },
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
                const Text('Record Turn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                TurnForm(
                  players: players,
                  clearOnSubmit: true,
                  onSubmit: (turn) {
                    context.read<GameState>().recordTurn(turn);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Turn Recorded')));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
