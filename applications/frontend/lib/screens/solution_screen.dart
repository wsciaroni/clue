import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_constants.dart';
import '../models/solution_probability.dart';
import '../state/game_state.dart';

class SolutionScreen extends StatelessWidget {
  const SolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final probs = gameState.solutionProbabilities;

        if (probs.isEmpty) {
          return const Center(child: Text('No deduction data available yet.'));
        }

        final suspects = _filterAndSort(probs, CardType.suspect);
        final weapons = _filterAndSort(probs, CardType.weapon);
        final rooms = _filterAndSort(probs, CardType.room);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Suspects', suspects),
              const SizedBox(height: 16),
              _buildSection('Weapons', weapons),
              const SizedBox(height: 16),
              _buildSection('Rooms', rooms),
            ],
          ),
        );
      },
    );
  }

  List<LocalSolutionProbability> _filterAndSort(
    List<LocalSolutionProbability> probs,
    CardType type,
  ) {
    final filtered = probs.where((p) => p.card.type == type).toList();
    // Sort by probability descending
    filtered.sort((a, b) => b.probability.compareTo(a.probability));
    return filtered;
  }

  Widget _buildSection(String title, List<LocalSolutionProbability> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...items.map((item) {
              if (item.isEliminated) {
                // Skip eliminated cards or show them crossed out?
                // User said: "percentages for cards that are not eliminated or confirmed."
                // User also said: "what cards I know are the correct answer"
                // Implies we show candidates. We can hide eliminated or show them at bottom.
                // Let's show eliminated at bottom, greyed out, strikethrough.
                return _buildRow(item);
              } else {
                return _buildRow(item);
              }
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(LocalSolutionProbability item) {
    final isConfirmed = item.probability >= 0.99; // Float precision
    final isEliminated = item.isEliminated;

    Color textColor = Colors.black;
    TextStyle style = const TextStyle(fontSize: 16);
    Widget? trailing;

    if (isConfirmed) {
      textColor = Colors.green;
      style = style.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      );
      trailing = const Icon(Icons.check_circle, color: Colors.green);
    } else if (isEliminated) {
      textColor = Colors.grey;
      style = style.copyWith(
        color: textColor,
        decoration: TextDecoration.lineThrough,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text(item.card.name, style: style)),
          if (!isEliminated && !isConfirmed)
            Text(
              '${(item.probability * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
