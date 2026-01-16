import 'package:flutter/material.dart';
import '../models/recommendation.dart';

class RecommendationSelectionScreen extends StatelessWidget {
  final List<Recommendation> recommendations;

  const RecommendationSelectionScreen({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Suggestion'),
      ),
      body: recommendations.isEmpty
          ? const Center(child: Text('No recommendations available.'))
          : ListView.builder(
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final rec = recommendations[index];
                return ListTile(
                  leading: const Icon(Icons.lightbulb_outline),
                  title: Text(
                      '${rec.suspect.name}, ${rec.weapon.name}, ${rec.room.name}'),
                  subtitle: Text('Benefit: ${rec.benefit.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.pop(context, rec);
                  },
                );
              },
            ),
    );
  }
}
