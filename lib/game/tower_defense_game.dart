// tower_defense_game.dart

import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'maps/level1_map.dart';

class TowerDefenseGame extends FlameGame
    with HasCollisionDetection, PanDetector {
  final Level1Map levelMap = Level1Map();
  double volume = 0.5;
  String difficulty = 'Normal';
  double difficultyMultiplier = 1.0;
  SpriteComponent? ghostTower;
  TextComponent? statusText;

  @override
  Future<void> onLoad() async {
    await _loadSettings();
    await _renderMap();
    camera.viewport = FixedResolutionViewport(resolution: Vector2(800, 600));
    camera.moveTo(Vector2.zero());

    final sprite = await loadSprite('towers/Cannon.png', srcSize: Vector2(32, 32));
    ghostTower = SpriteComponent(
      sprite: sprite,
      size: Vector2.all(32),
      paint: Paint()..color = const Color(0x80FFFFFF),
    );
    add(ghostTower!);

    statusText = TextComponent(
      text: '🎮 $difficulty | 🔊 ${(volume * 100).round()}%',
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
      priority: 10,
    );
    add(statusText!);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    volume = prefs.getDouble('volume') ?? 0.5;
    difficulty = prefs.getString('difficulty') ?? 'Normal';
    print('🔊 Volume: $volume | 🎮 Difficulty: $difficulty');

    switch (difficulty) {
      case 'Easy':
        difficultyMultiplier = 0.75;
        break;
      case 'Hard':
        difficultyMultiplier = 1.5;
        break;
      case 'Normal':
      default:
        difficultyMultiplier = 1.0;
    }
  }

  Future<void> _renderMap() async {
    for (int row = 0; row < levelMap.height; row++) {
      for (int col = 0; col < levelMap.width; col++) {
        final tileType = levelMap.tiles[row][col];
        final position = Vector2(col * levelMap.tileSize.toDouble(), row * levelMap.tileSize.toDouble());

        final sprite = await _getSpriteForTile(tileType);
        final tile = SpriteComponent()
          ..sprite = sprite
          ..position = position
          ..size = Vector2.all(levelMap.tileSize.toDouble());

        add(tile);
      }
    }
  }

  Future<Sprite> _getSpriteForTile(int tileType) async {
    final image = await images.load('tileset/jungle_tiles.png');
    switch (tileType) {
      case 1:
        return Sprite(image, srcPosition: Vector2(32, 0), srcSize: Vector2(32, 32));
      case 2:
        return Sprite(image, srcPosition: Vector2(64, 0), srcSize: Vector2(32, 32));
      case 3:
        return Sprite(image, srcPosition: Vector2(0, 32), srcSize: Vector2(32, 32));
      case 4:
        return Sprite(image, srcPosition: Vector2(32, 32), srcSize: Vector2(32, 32));
      case 0:
      default:
        return Sprite(image, srcPosition: Vector2(0, 0), srcSize: Vector2(32, 32));
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.moveBy(-info.delta.global);
  }

}
