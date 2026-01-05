import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../state/game_state.dart';

enum GroupBy { answerer, asker }

class ConstraintListScreen extends StatefulWidget {
  const ConstraintListScreen({super.key});

  @override
  State<ConstraintListScreen> createState() => _ConstraintListScreenState();
}

class _ConstraintListScreenState extends State<ConstraintListScreen> {
  GroupBy _groupBy = GroupBy.answerer;

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    final constraints = gameState.turnLog
        .where((t) => t.answeringPlayer != null)
        .toList();

    // Grouping
    Map<Player, List<GameTurn>> grouped;
    if (_groupBy == GroupBy.answerer) {
      grouped = {};
      for (var t in constraints) {
        grouped.putIfAbsent(t.answeringPlayer!, () => []).add(t);
      }
    } else {
      grouped = {};
      for (var t in constraints) {
        grouped.putIfAbsent(t.askingPlayer, () => []).add(t);
      }
    }

    // Sort keys (Players) by name
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Constraints'),
        actions: [
          PopupMenuButton<GroupBy>(
            initialValue: _groupBy,
            onSelected: (val) => setState(() => _groupBy = val),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: GroupBy.answerer,
                child: Text('Group by Answerer'),
              ),
              PopupMenuItem(
                value: GroupBy.asker,
                child: Text('Group by Asker'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: constraints.isEmpty
          ? const Center(child: Text('No constraints recorded yet.'))
          : ListView.builder(
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final player = sortedKeys[index];
                final playerTurns = grouped[player]!;

                playerTurns.sort((a, b) {
                  bool aResolved = _isResolved(a);
                  bool bResolved = _isResolved(b);
                  if (aResolved == bResolved) return 0;
                  return aResolved ? 1 : -1;
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Colors.grey.shade200,
                      width: double.infinity,
                      child: Text(
                        player.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ...playerTurns.map(
                      (turn) => _ConstraintCard(
                        turn: turn,
                        isResolved: _isResolved(turn),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  bool _isResolved(GameTurn turn) {
    if (turn.specificCardShown != null) return true;

    final p = turn.answeringPlayer!;

    if (p.getStatus(turn.suspect) == DeductionStatus.hasIt) return true;
    if (p.getStatus(turn.weapon) == DeductionStatus.hasIt) return true;
    if (p.getStatus(turn.room) == DeductionStatus.hasIt) return true;

    return false;
  }
}

class _ConstraintCard extends StatelessWidget {
  final GameTurn turn;
  final bool isResolved;

  const _ConstraintCard({required this.turn, required this.isResolved});

  @override
  Widget build(BuildContext context) {
    final answerer = turn.answeringPlayer!;

    return Opacity(
      opacity: isResolved ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row of cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCardIcon(turn.suspect, answerer),
                  _buildCardIcon(turn.weapon, answerer),
                  _buildCardIcon(turn.room, answerer),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Asked by: ${turn.askingPlayer.name} -> Answered by: ${answerer.name}',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardIcon(GameCard card, Player player) {
    final status = player.getStatus(card);

    IconData? overlayIcon;
    Color overlayColor = Colors.transparent;

    if (status == DeductionStatus.hasIt) {
      overlayIcon = Icons.check_circle;
      overlayColor = Colors.green;
    } else if (status == DeductionStatus.doesNotHaveIt) {
      overlayIcon = Icons.cancel;
      overlayColor = Colors.red;
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  card.name.substring(0, 1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            if (overlayIcon != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(overlayIcon, color: overlayColor, size: 20),
              ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          child: Text(
            card.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
