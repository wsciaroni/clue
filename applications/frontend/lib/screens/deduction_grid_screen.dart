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

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(
              label: Text(
                'Card',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...players.map((p) => DataColumn(label: Text(p.name))),
          ],
          rows: [
            ..._buildRows(GameConstants.suspects, players, 'Suspects'),
            ..._buildRows(GameConstants.weapons, players, 'Weapons'),
            ..._buildRows(GameConstants.rooms, players, 'Rooms'),
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildRows(
    List<GameCard> cards,
    List<Player> players,
    String sectionTitle,
  ) {
    final List<DataRow> rows = [];

    // Header for section
    rows.add(
      DataRow(
        color: WidgetStateProperty.all(Colors.grey.shade200),
        cells: [
          DataCell(
            Text(
              sectionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...players.map((_) => const DataCell(SizedBox())),
        ],
      ),
    );

    for (var card in cards) {
      rows.add(
        DataRow(
          cells: [
            DataCell(Text(card.name)),
            ...players.map((player) {
              final status = player.getStatus(card);
              return DataCell(_buildStatusIcon(status));
            }),
          ],
        ),
      );
    }
    return rows;
  }

  Widget _buildStatusIcon(DeductionStatus status) {
    switch (status) {
      case DeductionStatus.hasIt:
        return const Icon(Icons.check, color: Colors.green);
      case DeductionStatus.doesNotHaveIt:
        return const Icon(Icons.close, color: Colors.red);
      case DeductionStatus.unknown:
        return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }
}
