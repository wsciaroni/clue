import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/file_manager/file_manager.dart';
import '../state/game_state.dart';
import 'game_log_screen.dart';
import 'deduction_grid_screen.dart';
import 'widgets/connection_status_indicator.dart';

import 'solution_screen.dart';
import 'constraint_list_screen.dart';

class GameHome extends StatefulWidget {
  const GameHome({super.key});

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const GameLogScreen(),
    const DeductionGridScreen(),
    const ConstraintListScreen(),
    const SolutionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clue Assistant'),
        actions: [
          const ConnectionStatusIndicator(),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Game',
            onPressed: () async {
              try {
                final jsonString = context.read<GameState>().toJson();
                final String fileName =
                    'clue_save_${DateTime.now().millisecondsSinceEpoch}.json';

                final path =
                    await FileManager().saveFile(fileName, jsonString);

                if (path != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Game saved to $path')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save game: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Confirm reset
              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Reset Game?'),
                  content: const Text('This will clear all data.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<GameState>().reset();
                        Navigator.pop(c);
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Game Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on),
            label: 'Deduction Grid',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Constraints',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Solution',
          ),
        ],
      ),
    );
  }
}
