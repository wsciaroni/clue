import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../state/game_state.dart';

class DeductionGridScreen extends StatelessWidget {
  const DeductionGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final players = gameState.players;

    return Column(
      children: [
        // Header Row
        Container(
          color: Colors.blueGrey[900],
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              const SizedBox(
                width: 120, // Fixed width for the "Card" label
                child: Text(
                  'Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...players.map(
                (p) => Expanded(
                  child: Center(
                    child: Text(
                      p.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Scrollable Content
        Expanded(
          child: ListView(
            children: [
              ..._buildSection(GameConstants.suspects, players, 'Suspects', 0),
              ..._buildSection(
                GameConstants.weapons,
                players,
                'Weapons',
                GameConstants.suspects.length,
              ),
              ..._buildSection(
                GameConstants.rooms,
                players,
                'Rooms',
                GameConstants.suspects.length + GameConstants.weapons.length,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSection(
    List<GameCard> cards,
    List<Player> players,
    String title,
    int startIndex,
  ) {
    final List<Widget> widgets = [];

    // Section Header
    widgets.add(
      Container(
        color: Colors.blueGrey[100],
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        width: double.infinity,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );

    // Rows
    for (int i = 0; i < cards.length; i++) {
      final card = cards[i];
      final isEven = (startIndex + i) % 2 == 0;
      widgets.add(
        Container(
          color: isEven ? Colors.white : Colors.grey[100],
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  card.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ...players.map((player) {
                final status = player.getStatus(card);
                return Expanded(child: Center(child: _buildStatusIcon(status)));
              }),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildStatusIcon(DeductionStatus status) {
    switch (status) {
      case DeductionStatus.hasIt:
        return Container(
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(Icons.check, color: Colors.green, size: 20),
        );
      case DeductionStatus.doesNotHaveIt:
        return const Icon(Icons.close, color: Colors.red, size: 20);
      case DeductionStatus.unknown:
        return const SizedBox(width: 20, height: 20);
      case DeductionStatus.mightHaveIt:
        return const Icon(Icons.question_mark, color: Colors.orange, size: 20);
    }
  }
}
