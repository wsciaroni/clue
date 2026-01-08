import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../models/game_constants.dart';
import '../state/game_state.dart';
import '../services/file_manager/file_manager.dart';

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

  // Controllers for card counts
  final List<TextEditingController> _cardCountControllers = [
    TextEditingController(text: '3'),
    TextEditingController(text: '3'),
    TextEditingController(text: '3'),
  ];

  // Selected cards for user's hand
  final Set<GameCard> _selectedHand = {};

  void _addPlayer() {
    setState(() {
      _playerControllers.add(TextEditingController(text: 'Player ${_playerControllers.length + 1}'));
      _cardCountControllers.add(TextEditingController(text: '3'));
    });
  }

  void _removePlayer() {
    if (_playerControllers.length > 2) {
      setState(() {
        _playerControllers.removeLast();
        _cardCountControllers.removeLast();
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
      final counts = _cardCountControllers
          .map((c) => int.tryParse(c.text) ?? 0)
          .toList();

      context.read<GameState>().startGame(
        names,
        _selectedHand.toList(),
        cardCounts: counts,
      );
    }
  }

  Future<void> _loadGame() async {
    // Show Dialog to choose method
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Load Game"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text("Browse System Files"),
              onTap: () {
                Navigator.pop(context);
                _pickFromSystem();
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text("Load from Internal Storage"),
              onTap: () {
                Navigator.pop(context);
                _pickFromInternal();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromSystem() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final content = await FileManager().readPlatformFile(result.files.single);
        if (mounted) {
          await context.read<GameState>().loadGame(content);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load game: $e')),
        );
      }
    }
  }

  Future<void> _pickFromInternal() async {
     try {
       final files = await FileManager().listSavedFiles();
       if (!mounted) return;

       if (files.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('No internal saves found.')),
         );
         return;
       }

       showDialog(
         context: context,
         builder: (context) => AlertDialog(
           title: const Text("Select Save"),
           content: SizedBox(
             width: double.maxFinite,
             child: ListView.builder(
               shrinkWrap: true,
               itemCount: files.length,
               itemBuilder: (context, index) {
                 final path = files[index];
                 final name = path.split('/').last; // simple name extraction
                 return ListTile(
                   title: Text(name),
                   onTap: () async {
                     Navigator.pop(context); // close dialog
                     try {
                        String content = await FileManager().readFile(path);
                        if (context.mounted) {
                           await context.read<GameState>().loadGame(content);
                        }
                     } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to read file: $e')),
                          );
                        }
                     }
                   },
                 );
               },
             ),
           ),
         ),
       );

     } catch (e) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error listing files: $e')),
         );
       }
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clue Setup'),
        actions: [
          IconButton(
            onPressed: _loadGame,
            icon: const Icon(Icons.file_upload),
            tooltip: 'Load Game',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text('Players', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ..._playerControllers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: entry.key == 0 ? 'My Name (User)' : 'Player ${entry.key + 1}',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _cardCountControllers[entry.key],
                        decoration: const InputDecoration(
                          labelText: 'Cards',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => int.tryParse(value ?? '') == null ? 'Invalid' : null,
                      ),
                    ),
                  ],
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
