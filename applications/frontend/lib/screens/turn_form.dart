import 'package:flutter/material.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../state/game_state.dart';

class TurnForm extends StatefulWidget {
  final List<Player> players;
  final GameTurn? initialTurn;
  final Function(GameTurn) onSubmit;

  const TurnForm({
    super.key,
    required this.players,
    required this.onSubmit,
    this.initialTurn,
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

  bool _isAccusation = false;
  bool _wasAccusationCorrect = false;

  bool _someoneAnswered = true;
  GameCard? _specificCardShown;

  @override
  void initState() {
    super.initState();
    if (widget.initialTurn != null) {
      _loadInitialData(widget.initialTurn!);
    }
  }

  void _loadInitialData(GameTurn turn) {
    _askingPlayer = turn.askingPlayer;
    _selectedSuspect = turn.suspect;
    _selectedWeapon = turn.weapon;
    _selectedRoom = turn.room;
    _isAccusation = turn.isAccusation;
    _wasAccusationCorrect = turn.wasCorrect;

    if (_isAccusation) {
      _someoneAnswered = false;
      _answeringPlayer = null;
      _specificCardShown = null;
    } else {
      if (turn.answeringPlayer != null) {
        _someoneAnswered = true;
        _answeringPlayer = turn.answeringPlayer;
        _specificCardShown = turn.specificCardShown;
      } else {
        _someoneAnswered = false;
        _answeringPlayer = null;
        _specificCardShown = null;
      }
    }
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
            items: widget.players
                .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                .toList(),
            onChanged: (val) => setState(() => _askingPlayer = val),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Suspect
          DropdownButtonFormField<GameCard>(
            decoration: const InputDecoration(labelText: 'Suspect'),
            value: _selectedSuspect,
            items: GameConstants.suspects
                .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                .toList(),
            onChanged: (val) => setState(() => _selectedSuspect = val),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Weapon
          DropdownButtonFormField<GameCard>(
            decoration: const InputDecoration(labelText: 'Weapon'),
            value: _selectedWeapon,
            items: GameConstants.weapons
                .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                .toList(),
            onChanged: (val) => setState(() => _selectedWeapon = val),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Room
          DropdownButtonFormField<GameCard>(
            decoration: const InputDecoration(labelText: 'Room'),
            value: _selectedRoom,
            items: GameConstants.rooms
                .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                .toList(),
            onChanged: (val) => setState(() => _selectedRoom = val),
            validator: (val) => val == null ? 'Required' : null,
          ),

          const SizedBox(height: 10),
          ToggleButtons(
            isSelected: [_isAccusation == false, _isAccusation == true],
            onPressed: (index) {
              setState(() {
                _isAccusation = index == 1;
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Suggestion"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Accusation"),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (_isAccusation) ...[
            const Text(
              "Was the accusation correct?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: _wasAccusationCorrect,
                    onChanged: (val) => setState(() => _wasAccusationCorrect = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: _wasAccusationCorrect,
                    onChanged: (val) => setState(() => _wasAccusationCorrect = val!),
                  ),
                ),
              ],
            ),
          ] else ...[
            SwitchListTile(
              title: const Text('Did someone answer?'),
              value: _someoneAnswered,
              onChanged: (val) {
                setState(() {
                  _someoneAnswered = val;
                  if (!val) {
                    _answeringPlayer = null;
                    _specificCardShown = null;
                  }
                });
              },
            ),

            if (_someoneAnswered) ...[
              // Who Answered?
              DropdownButtonFormField<Player>(
                decoration: const InputDecoration(labelText: 'Who Answered?'),
                value: _answeringPlayer,
                items: widget.players
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                    .toList(),
                onChanged: (val) => setState(() => _answeringPlayer = val),
                validator: (val) {
                  if (!_someoneAnswered) return null;
                  if (val == null) return 'Required';
                  if (val == _askingPlayer) return 'Asker cannot answer';
                  return null;
                },
              ),

              DropdownButtonFormField<GameCard>(
                decoration: const InputDecoration(
                  labelText: 'Which card? (Optional/Private)',
                ),
                value: _specificCardShown,
                items: [
                  const DropdownMenuItem<GameCard>(
                    value: null,
                    child: Text('Unknown / Private'),
                  ),
                  if (_selectedSuspect != null)
                    DropdownMenuItem(
                      value: _selectedSuspect,
                      child: Text(_selectedSuspect!.name),
                    ),
                  if (_selectedWeapon != null)
                    DropdownMenuItem(
                      value: _selectedWeapon,
                      child: Text(_selectedWeapon!.name),
                    ),
                  if (_selectedRoom != null)
                    DropdownMenuItem(
                      value: _selectedRoom,
                      child: Text(_selectedRoom!.name),
                    ),
                ],
                onChanged: (val) => setState(() => _specificCardShown = val),
              ),
            ],
          ],

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.initialTurn == null ? 'Submit Turn' : 'Save Changes'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final turn = GameTurn(
        id: widget.initialTurn?.id, // Preserve ID if editing
        askingPlayer: _askingPlayer!,
        suspect: _selectedSuspect!,
        weapon: _selectedWeapon!,
        room: _selectedRoom!,
        answeringPlayer: (_isAccusation || !_someoneAnswered)
            ? null
            : _answeringPlayer,
        specificCardShown: (_isAccusation) ? null : _specificCardShown,
        isAccusation: _isAccusation,
        wasCorrect: _isAccusation ? _wasAccusationCorrect : false,
      );

      widget.onSubmit(turn);

      if (widget.initialTurn == null) {
        // Only clear if creating new turn
        setState(() {
          _answeringPlayer = null;
          _someoneAnswered = true;
          _specificCardShown = null;
          _selectedSuspect = null;
          _selectedWeapon = null;
          _selectedRoom = null;
          _isAccusation = false;
          _wasAccusationCorrect = false;
        });
      }
    }
  }
}
