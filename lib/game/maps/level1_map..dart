import 'package:flame/components.dart';
import 'map_utils.dart';

class Level1Map {
  final int width = 100;
  final int height = 60;
  final int tileSize = 32;

  late List<List<int>> tiles;
  late List<Vector2> path;
  late List<Vector2> towerSpots;

  Level1Map() {
    tiles = List.generate(height, (_) => List.filled(width, MapUtils.grass));
    MapUtils.fill(tiles, MapUtils.grass);
    path = MapUtils.straightPath(tiles, 30, tileSize);
    MapUtils.drawRiver(tiles, 10, MapUtils.river);

    MapUtils.scatterFlowers(
      tiles,
      [
        Vector2(5, 28),
        Vector2(7, 32),
        Vector2(15, 28),
        Vector2(17, 32),
        Vector2(22, 28),
        Vector2(25, 32),
      ],
      tileSize,
      MapUtils.flower,
    );

    towerSpots = MapUtils.generateTowerSpots([
      Vector2(10, 28),
      Vector2(15, 32),
      Vector2(20, 28),
      Vector2(25, 32),
      Vector2(30, 28),
      Vector2(35, 32),
    ], tileSize);
  }
}
