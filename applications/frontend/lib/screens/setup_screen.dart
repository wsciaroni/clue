import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_constants.dart';
import '../state/game_state.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for player names
  final List<TextEditingController> _playerControllers = [
    TextEditingController(text: 'Me'),
    TextEditingController(text: 'Player 2'),
    TextEditingController(text: 'Player 3'),
  ];

  // Selected cards for user's hand
  final Set<GameCard> _selectedHand = {};

  void _addPlayer() {
    setState(() {
      _playerControllers.add(TextEditingController(text: 'Player ${_playerControllers.length + 1}'));
    });
  }

  void _removePlayer() {
    if (_playerControllers.length > 2) {
      setState(() {
        _playerControllers.removeLast();
      });
    }
  }

  void _toggleCard(GameCard card) {
    setState(() {
      if (_selectedHand.contains(card)) {
        _selectedHand.remove(card);
      } else {
        _selectedHand.add(card);
      }
    });
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      final names = _playerControllers.map((c) => c.text).toList();
      context.read<GameState>().startGame(names, _selectedHand.toList());
      // Navigation is handled by the main wrapper listening to gameStarted,
      // or we can push manually.
      // But based on the plan, we'll likely have a wrapper in main or home.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clue Setup')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text('Players', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ..._playerControllers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: entry.key == 0 ? 'My Name (User)' : 'Player ${entry.key + 1}',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    if (value.toUpperCase() == 'NO_ONE') {
                      return 'Name cannot be "NO_ONE"';
                    }
                    return null;
                  },
                ),
              );
            }),
            Row(
              children: [
                IconButton(onPressed: _addPlayer, icon: const Icon(Icons.add_circle), color: Colors.green),
                const Text('Add Player'),
                const SizedBox(width: 20),
                IconButton(onPressed: _removePlayer, icon: const Icon(Icons.remove_circle), color: Colors.red),
                const Text('Remove Player'),
              ],
            ),
            const Divider(height: 32),
            const Text('My Hand', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Select the cards currently in your hand.'),
            const SizedBox(height: 10),

            _buildCardSection('Suspects', GameConstants.suspects),
            _buildCardSection('Weapons', GameConstants.weapons),
            _buildCardSection('Rooms', GameConstants.rooms),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              child: const Text('Start Game', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(String title, List<GameCard> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Wrap(
          spacing: 8.0,
          children: cards.map((card) {
            final isSelected = _selectedHand.contains(card);
            return FilterChip(
              label: Text(card.name),
              selected: isSelected,
              onSelected: (_) => _toggleCard(card),
            );
          }).toList(),
        ),
      ],
    );
  }
}
