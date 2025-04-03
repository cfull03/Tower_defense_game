import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/tower_defense_game.dart';

class GameScreen extends StatelessWidget {
  final TowerDefenseGame _game = TowerDefenseGame();

  GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: _game),
    );
  }
}
