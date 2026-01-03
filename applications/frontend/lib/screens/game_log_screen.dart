import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../state/game_state.dart';

class GameLogScreen extends StatefulWidget {
  const GameLogScreen({super.key});

  @override
  State<GameLogScreen> createState() => _GameLogScreenState();
}

class _GameLogScreenState extends State<GameLogScreen> {
  final _formKey = GlobalKey<FormState>();

  Player? _askingPlayer;
  Player? _answeringPlayer;
  GameCard? _selectedSuspect;
  GameCard? _selectedWeapon;
  GameCard? _selectedRoom;

  bool _cardShown = false;
  GameCard? _specificCardShown; // Optional

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
              );
            },
          ),
        ),
        const Divider(),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Record Turn', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),

                  // Who asked?
                  DropdownButtonFormField<Player>(
                    decoration: const InputDecoration(labelText: 'Who Asked?'),
                    value: _askingPlayer,
                    items: players.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                    onChanged: (val) => setState(() => _askingPlayer = val),
                    validator: (val) => val == null ? 'Required' : null,
                  ),

                  // Suspect
                  DropdownButtonFormField<GameCard>(
                    decoration: const InputDecoration(labelText: 'Suspect'),
                    value: _selectedSuspect,
                    items: GameConstants.suspects.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                    onChanged: (val) => setState(() => _selectedSuspect = val),
                    validator: (val) => val == null ? 'Required' : null,
                  ),

                  // Weapon
                  DropdownButtonFormField<GameCard>(
                    decoration: const InputDecoration(labelText: 'Weapon'),
                    value: _selectedWeapon,
                    items: GameConstants.weapons.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                    onChanged: (val) => setState(() => _selectedWeapon = val),
                    validator: (val) => val == null ? 'Required' : null,
                  ),

                  // Room
                  DropdownButtonFormField<GameCard>(
                    decoration: const InputDecoration(labelText: 'Room'),
                    value: _selectedRoom,
                    items: GameConstants.rooms.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                    onChanged: (val) => setState(() => _selectedRoom = val),
                    validator: (val) => val == null ? 'Required' : null,
                  ),

                  // Who Answered?
                  DropdownButtonFormField<Player>(
                    decoration: const InputDecoration(labelText: 'Who Answered?'),
                    value: _answeringPlayer,
                    items: players.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                    onChanged: (val) => setState(() => _answeringPlayer = val),
                    validator: (val) {
                      if (val == null) return 'Required';
                      if (val == _askingPlayer) return 'Asker cannot answer';
                      return null;
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Did they show a card?'),
                    value: _cardShown,
                    onChanged: (val) {
                      setState(() {
                        _cardShown = val;
                        if (!val) _specificCardShown = null;
                      });
                    },
                  ),

                  if (_cardShown)
                    DropdownButtonFormField<GameCard>(
                      decoration: const InputDecoration(labelText: 'Which card? (Optional/Private)'),
                      value: _specificCardShown,
                      items: [
                        const DropdownMenuItem<GameCard>(value: null, child: Text('Unknown / Private')),
                        if (_selectedSuspect != null) DropdownMenuItem(value: _selectedSuspect, child: Text(_selectedSuspect!.name)),
                        if (_selectedWeapon != null) DropdownMenuItem(value: _selectedWeapon, child: Text(_selectedWeapon!.name)),
                        if (_selectedRoom != null) DropdownMenuItem(value: _selectedRoom, child: Text(_selectedRoom!.name)),
                      ],
                      onChanged: (val) => setState(() => _specificCardShown = val),
                    ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitTurn,
                    child: const Text('Submit Turn'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitTurn() {
    if (_formKey.currentState!.validate()) {
      final turn = GameTurn(
        askingPlayer: _askingPlayer!,
        suspect: _selectedSuspect!,
        weapon: _selectedWeapon!,
        room: _selectedRoom!,
        answeringPlayer: _answeringPlayer!,
        cardShown: _cardShown,
        specificCardShown: _specificCardShown,
      );

      context.read<GameState>().recordTurn(turn);

      // Reset form fields slightly for convenience, but keep asker?
      setState(() {
         // _askingPlayer = null; // Optional: keep or clear
         _answeringPlayer = null;
         _cardShown = false;
         _specificCardShown = null;
         // Keep selected cards as they might be similar next turn? Or clear them.
         // Let's clear them to avoid mistakes.
         _selectedSuspect = null;
         _selectedWeapon = null;
         _selectedRoom = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Turn Recorded')));
    }
  }
}
