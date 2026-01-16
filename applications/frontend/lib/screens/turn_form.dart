import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_constants.dart';
import '../models/player.dart';
import '../models/recommendation.dart';
import '../state/game_state.dart';
import 'recommendation_selection_screen.dart';

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
            decoration: const InputDecoration(
              labelText: 'Who Asked?',
              prefixIcon: Icon(Icons.person),
            ),
            initialValue: _askingPlayer,
            items: widget.players
                .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                .toList(),
            onChanged: (val) => setState(() => _askingPlayer = val),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Suspect
          DropdownButtonFormField<GameCard>(
            decoration: const InputDecoration(
              labelText: 'Suspect',
              prefixIcon: Icon(Icons.person),
            ),
            initialValue: _selectedSuspect,
            items: GameConstants.suspects
                .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                .toList(),
            onChanged: (val) => setState(() => _selectedSuspect = val),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Weapon
          DropdownButtonFormField<GameCard>(
            decoration: const InputDecoration(
              labelText: 'Weapon',
              prefixIcon: Icon(Icons.build),
            ),
            initialValue: _selectedWeapon,
            items: GameConstants.weapons
                .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                .toList(),
            onChanged: (val) => setState(() => _selectedWeapon = val),
            validator: (val) => val == null ? 'Required' : null,
          ),

          // Room
          DropdownButtonFormField<GameCard>(
            decoration: const InputDecoration(
              labelText: 'Room',
              prefixIcon: Icon(Icons.meeting_room),
            ),
            initialValue: _selectedRoom,
            items: GameConstants.rooms
                .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                .toList(),
            onChanged: (val) => setState(() => _selectedRoom = val),
            validator: (val) => val == null ? 'Required' : null,
          ),

          if (_isAccusation)
            TextButton.icon(
              onPressed: _getAccusationRecommendation,
              icon: const Icon(Icons.lightbulb),
              label: const Text("Recommend Accusation"),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed:
                        _selectedRoom == null ? null : _getRoomSuggestion,
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text("Room Hint"),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: _getAllSuggestions,
                    icon: const Icon(Icons.lightbulb),
                    label: const Text("All Hints"),
                  ),
                ),
              ],
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
            RadioGroup<bool>(
              groupValue: _wasAccusationCorrect,
              onChanged: (val) {
                if (val != null) {
                  setState(() => _wasAccusationCorrect = val);
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text("Yes"),
                      value: true,
                      // groupValue and onChanged are removed here; handled by RadioGroup
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text("No"),
                      value: false,
                      // groupValue and onChanged are removed here; handled by RadioGroup
                    ),
                  ),
                ],
              ),
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
                decoration: const InputDecoration(
                  labelText: 'Who Answered?',
                  prefixIcon: Icon(Icons.person),
                ),
                initialValue: _answeringPlayer,
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
                  prefixIcon: Icon(Icons.visibility),
                ),
                initialValue: _specificCardShown,
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
            child: Text(
              widget.initialTurn == null ? 'Submit Turn' : 'Save Changes',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getAccusationRecommendation() async {
    final gameState = context.read<GameState>();
    final rec = await gameState.getAccusationRecommendation();
    if (!mounted) return;
    if (rec != null) {
      _showRecommendationDialog(rec);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No accusation recommendation found.')),
      );
    }
  }

  Future<void> _getRoomSuggestion() async {
    await _getSuggestion(roomName: _selectedRoom?.name);
  }

  Future<void> _getAllSuggestions() async {
    await _getSuggestion(roomName: null);
  }

  Future<void> _getSuggestion({String? roomName}) async {
    final gameState = context.read<GameState>();
    final recs = await gameState.getSuggestions(
      roomName: roomName,
    );
    if (!mounted) return;

    if (recs.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No suggestions found.')));
    } else if (recs.length == 1) {
      _showRecommendationDialog(recs.first);
    } else {
      // Multiple recommendations -> Go to selection screen
      final selected = await Navigator.push<Recommendation>(
        context,
        MaterialPageRoute(
          builder:
              (context) => RecommendationSelectionScreen(recommendations: recs),
        ),
      );
      if (selected != null) {
        _applyRecommendation(selected);
      }
    }
  }

  void _showRecommendationDialog(Recommendation rec) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Recommendation"),
            content: Text(
              "We recommend asking about:\n\nSuspect: ${rec.suspect.name}\nWeapon: ${rec.weapon.name}\nRoom: ${rec.room.name}\n\nBenefit: ${rec.benefit.toStringAsFixed(2)}",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _applyRecommendation(rec);
                },
                child: const Text("Use"),
              ),
            ],
          ),
    );
  }

  void _applyRecommendation(Recommendation rec) {
    setState(() {
      _selectedSuspect = rec.suspect;
      _selectedWeapon = rec.weapon;
      _selectedRoom = rec.room;
    });
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
