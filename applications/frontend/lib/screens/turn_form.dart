import 'package:flutter/material.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../state/game_state.dart';

class TurnForm extends StatefulWidget {
  final List<Player> players;
  final GameTurn? initialTurn;
  final Function(GameTurn) onSubmit;
  final String submitLabel;
  final bool clearOnSubmit;

  const TurnForm({
    super.key,
    required this.players,
    required this.onSubmit,
    this.initialTurn,
    this.submitLabel = 'Submit Turn',
    this.clearOnSubmit = false,
  });

  @override
  State<TurnForm> createState() => _TurnFormState();
}

class _TurnFormState extends State<TurnForm> {
  final _formKey = GlobalKey<FormState>();

  Player? _askingPlayer;
  Player? _answeringPlayer;
  GameCard? _selectedSuspect;
  GameCard? _selectedWeapon;
  GameCard? _selectedRoom;

  bool _cardShown = false;
  GameCard? _specificCardShown;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.initialTurn != null) {
      _askingPlayer = widget.initialTurn!.askingPlayer;
      _answeringPlayer = widget.initialTurn!.answeringPlayer;
      _selectedSuspect = widget.initialTurn!.suspect;
      _selectedWeapon = widget.initialTurn!.weapon;
      _selectedRoom = widget.initialTurn!.room;
      _cardShown = widget.initialTurn!.cardShown;
      _specificCardShown = widget.initialTurn!.specificCardShown;
    } else {
      _askingPlayer = null;
      _answeringPlayer = null;
      _selectedSuspect = null;
      _selectedWeapon = null;
      _selectedRoom = null;
      _cardShown = false;
      _specificCardShown = null;
    }
  }

  void _submit() {
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

      widget.onSubmit(turn);

      if (widget.clearOnSubmit) {
        setState(() {
           // Keep asking player? The original code kept nothing or something.
           // Original code: _answeringPlayer = null; _cardShown = false; _specificCardShown = null; _selectedSuspect = null...
           // Let's clear everything except maybe asking player?
           // The original code commented out // _askingPlayer = null;
           // So it implicitly KEPT askingPlayer.
           // But let's just clear mandatory fields that change.

           _answeringPlayer = null;
           _cardShown = false;
           _specificCardShown = null;
           _selectedSuspect = null;
           _selectedWeapon = null;
           _selectedRoom = null;
           // We keep _askingPlayer as is convenient.
        });
      }
    }
  }

  List<DropdownMenuItem<GameCard>> _buildCardShownItems() {
    final items = <DropdownMenuItem<GameCard>>[
      const DropdownMenuItem<GameCard>(value: null, child: Text('Unknown / Private')),
    ];

    // Helper to add unique items.
    // Logic: The options for "Which card?" should primarily be the selected Suspect, Weapon, and Room.
    // However, if we are Editing, and the saved `_specificCardShown` is somehow NOT one of the currently selected 3
    // (e.g. state drift or partial update), we must include it to avoid crash.
    // BUT normally, it should be one of them.
    // If `_specificCardShown` matches one of them by equality, we should use the *current* instance from selectedX to be clean,
    // although `GameCard` equality should suffice.

    // We'll create a set of candidates from the current selection.
    final candidates = {
      if (_selectedSuspect != null) _selectedSuspect!,
      if (_selectedWeapon != null) _selectedWeapon!,
      if (_selectedRoom != null) _selectedRoom!,
    };

    // If _specificCardShown is set but not in candidates (e.g. initializing or user changed a dropdown above),
    // we should technically include it to prevent crash, OR allow it to be deselected.
    // Ideally, if the user changes Suspect, and the old Suspect was the specific card shown, we should probably clear specific card.
    // But for now, let's just ensure the list contains the value if it exists.

    if (_specificCardShown != null && !candidates.contains(_specificCardShown)) {
       // It's an orphan value. We add it so the dropdown can display it (prevent crash),
       // likely the user will change it or it's a transient state.
       items.add(DropdownMenuItem(value: _specificCardShown, child: Text(_specificCardShown!.name)));
    }

    for (var c in candidates) {
      items.add(DropdownMenuItem(value: c, child: Text(c.name)));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Who asked?
          DropdownButtonFormField<Player>(
            decoration: const InputDecoration(labelText: 'Who Asked?'),
            value: _askingPlayer,
            items: widget.players.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
            onChanged: (val) => setState(() => _askingPlayer = val),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Suspect
          DropdownButtonFormField<GameCard>(
            decoration: const InputDecoration(labelText: 'Suspect'),
            value: _selectedSuspect,
            items: GameConstants.suspects.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
            onChanged: (val) => setState(() {
              if (_specificCardShown == _selectedSuspect) {
                _specificCardShown = val;
              }
              _selectedSuspect = val;
            }),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Weapon
          DropdownButtonFormField<GameCard>(
            decoration: const InputDecoration(labelText: 'Weapon'),
            value: _selectedWeapon,
            items: GameConstants.weapons.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
            onChanged: (val) => setState(() {
              if (_specificCardShown == _selectedWeapon) {
                _specificCardShown = val;
              }
              _selectedWeapon = val;
            }),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Room
          DropdownButtonFormField<GameCard>(
            decoration: const InputDecoration(labelText: 'Room'),
            value: _selectedRoom,
            items: GameConstants.rooms.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
            onChanged: (val) => setState(() {
              if (_specificCardShown == _selectedRoom) {
                _specificCardShown = val;
              }
              _selectedRoom = val;
            }),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Who Answered?
          DropdownButtonFormField<Player>(
            decoration: const InputDecoration(labelText: 'Who Answered?'),
            value: _answeringPlayer,
            items: widget.players.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
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
              items: _buildCardShownItems(),
              onChanged: (val) => setState(() => _specificCardShown = val),
            ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }
}
