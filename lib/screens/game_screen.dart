import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/tower_defense_game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of the game
    final TowerDefenseGame game = TowerDefenseGame();

    return Scaffold(
      body: Stack(
        children: [
          // Load the game inside the GameWidget
          GameWidget(game: game),

          // Exit button to go back to the main menu
          Positioned(
            top: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
          ),
        ],
      ),
    );
  }
}
