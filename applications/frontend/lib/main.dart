import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/game_state.dart';
import 'screens/setup_screen.dart';
import 'screens/game_home.dart';

void main() {
  runApp(const ClueApp());
}

class ClueApp extends StatelessWidget {
  const ClueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Clue Assistant',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AppOrchestrator(),
      ),
    );
  }
}

class AppOrchestrator extends StatelessWidget {
  const AppOrchestrator({super.key});

  @override
  Widget build(BuildContext context) {
    final gameStarted = context.select<GameState, bool>((state) => state.gameStarted);

    if (gameStarted) {
      return const GameHome();
    } else {
      return const SetupScreen();
    }
  }
}
