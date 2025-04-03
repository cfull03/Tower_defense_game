// level1_map.dart

import 'package:flame/components.dart';

class Level1Map {
  static const int grass = 0;
  static const int dirt = 1;
  static const int flower = 2;
  static const int pathTile = 3;
  static const int river = 4;

  final int width = 100;
  final int height = 60;
  final int tileSize = 32;

  late List<List<int>> tiles;
  late List<Vector2> path;
  late List<Vector2> towerSpots;

  Level1Map() {
    tiles = List.generate(height, (_) => List.filled(width, grass));
    _generatePath();
    _generateRiver();
    _placeFlowers();
    _placeTowerSpots();
  }

  void _generatePath() {
    path = [];
    int row = 30;
    for (int col = 0; col < width; col++) {
      tiles[row][col] = pathTile;
      path.add(Vector2(col * tileSize.toDouble(), row * tileSize.toDouble()));
    }
  }

  void _generateRiver() {
    for (int col = 0; col < width; col++) {
      tiles[10][col] = river;
    }
  }

  void _placeFlowers() {
    for (int i = 0; i < 50; i += 5) {
      tiles[28][i] = flower;
      tiles[32][i + 2] = flower;
    }
  }

  void _placeTowerSpots() {
    towerSpots = [];
    for (int i = 10; i < 90; i += 20) {
      towerSpots.add(Vector2(i * tileSize.toDouble(), 28 * tileSize.toDouble()));
      towerSpots.add(Vector2(i * tileSize.toDouble(), 32 * tileSize.toDouble()));
    }
  }
}
