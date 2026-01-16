import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/game_constants.dart';
import 'package:frontend/models/recommendation.dart';
import 'package:frontend/screens/recommendation_selection_screen.dart';

void main() {
  testWidgets('RecommendationSelectionScreen displays recommendations',
      (WidgetTester tester) async {
    final rec1 = Recommendation(
      suspect: GameConstants.suspects[0], // Mustard
      weapon: GameConstants.weapons[0],   // Candlestick
      room: GameConstants.rooms[0],       // Kitchen
      benefit: 0.5,
    );
    final rec2 = Recommendation(
      suspect: GameConstants.suspects[1], // Scarlet
      weapon: GameConstants.weapons[1],   // Knife
      room: GameConstants.rooms[1],       // Ballroom
      benefit: 0.8,
    );

    await tester.pumpWidget(MaterialApp(
      home: RecommendationSelectionScreen(recommendations: [rec1, rec2]),
    ));

    expect(find.text('Select a Suggestion'), findsOneWidget);
    expect(find.textContaining('Colonel Mustard, Candlestick, Kitchen'), findsOneWidget);
    expect(find.textContaining('Benefit: 0.50'), findsOneWidget);
    expect(find.textContaining('Miss Scarlet, Knife, Ballroom'), findsOneWidget);
    expect(find.textContaining('Benefit: 0.80'), findsOneWidget);
  });

  testWidgets('RecommendationSelectionScreen returns selected recommendation',
      (WidgetTester tester) async {
    final rec1 = Recommendation(
      suspect: GameConstants.suspects[0],
      weapon: GameConstants.weapons[0],
      room: GameConstants.rooms[0],
      benefit: 0.5,
    );

    Recommendation? selectedRec;

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () async {
            selectedRec = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecommendationSelectionScreen(recommendations: [rec1]),
              ),
            );
          },
          child: const Text('Go'),
        );
      }),
    ));

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Colonel Mustard'));
    await tester.pumpAndSettle();

    expect(selectedRec, rec1);
  });
}
