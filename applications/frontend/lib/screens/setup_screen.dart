import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Controllers for connection settings
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  // Selected cards for user's hand
  final Set<GameCard> _selectedHand = {};

  @override
  void initState() {
    super.initState();
    _loadConnectionSettings();
    _cardCountControllers[0].addListener(_updateState);
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    for (var controller in _playerControllers) {
      controller.dispose();
    }
    for (var controller in _cardCountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  Future<void> _loadConnectionSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hostController.text = prefs.getString('connection_host') ?? '';
      _portController.text = (prefs.getInt('connection_port') ?? '').toString();
    });
  }

  Future<void> _saveConnectionSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('connection_host', _hostController.text);
    int? port = int.tryParse(_portController.text);
    if (port != null) {
      await prefs.setInt('connection_port', port);
    }
  }

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

  Future<void> _startGame() async {
    if (_formKey.currentState!.validate()) {
      // Validate card count for user
      final userExpectedCount = int.tryParse(_cardCountControllers[0].text) ?? 0;
      if (_selectedHand.length != userExpectedCount) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Selected ${_selectedHand.length} cards, but expected $userExpectedCount. Please ensure "My Hand" matches the expected count.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      await _saveConnectionSettings();

      if (mounted) {
        final host = _hostController.text.isNotEmpty ? _hostController.text : null;
        final port = int.tryParse(_portController.text);

        if (host != null || port != null) {
           context.read<GameState>().updateConnectionSettings(host, port);
        }
      }

      final names = _playerControllers.map((c) => c.text).toList();
      final counts = _cardCountControllers
          .map((c) => int.tryParse(c.text) ?? 0)
          .toList();

      if (mounted) {
        context.read<GameState>().startGame(
          names,
          _selectedHand.toList(),
          cardCounts: counts,
        );
      }
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
            ExpansionTile(
              title: const Text('Connection Settings'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hostController,
                          decoration: const InputDecoration(
                            labelText: 'Host (Optional)',
                            hintText: 'localhost',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _portController,
                          decoration: const InputDecoration(
                            labelText: 'Port (Optional)',
                            hintText: '50051',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: _playerControllers.length < 6 ? _addPlayer : null,
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Add Player'),
                  style: TextButton.styleFrom(foregroundColor: Colors.green),
                ),
                TextButton.icon(
                  onPressed:
                      _playerControllers.length > 2 ? _removePlayer : null,
                  icon: const Icon(Icons.remove_circle),
                  label: const Text('Remove Player'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              children: [
                const Text(
                  'My Hand',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  '(Selected: ${_selectedHand.length} / ${_cardCountControllers[0].text})',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        _selectedHand.length ==
                                (int.tryParse(_cardCountControllers[0].text) ??
                                    0)
                            ? Colors.green
                            : Colors.orange,
                  ),
                ),
              ],
            ),
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
