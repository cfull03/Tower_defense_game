import 'package:flame/components.dart';

class MapUtils {
  static const int grass = 0;
  static const int dirt = 1;
  static const int flower = 2;
  static const int pathTile = 3;
  static const int river = 4;

  static void fill(List<List<int>> tiles, int tileType) {
    for (int y = 0; y < tiles.length; y++) {
      for (int x = 0; x < tiles[y].length; x++) {
        tiles[y][x] = tileType;
      }
    }
  }

  static List<Vector2> straightPath(List<List<int>> tiles, int y, int tileSize) {
    final path = <Vector2>[];
    for (int x = 0; x < tiles[0].length; x++) {
      tiles[y][x] = pathTile;
      path.add(Vector2(x * tileSize.toDouble(), y * tileSize.toDouble()));
    }
    return path;
  }

  static void drawRiver(List<List<int>> tiles, int y, int tileType) {
    for (int x = 0; x < tiles[0].length; x++) {
      tiles[y][x] = tileType;
    }
  }

  static void scatterFlowers(List<List<int>> tiles, List<Vector2> points, int tileSize, int flowerTile) {
    for (final p in points) {
      final col = (p.x ~/ tileSize);
      final row = (p.y ~/ tileSize);
      if (row < tiles.length && col < tiles[row].length) {
        tiles[row][col] = flowerTile;
      }
    }
  }

  static List<Vector2> generateTowerSpots(List<Vector2> coords, int tileSize) {
    return coords.map((p) => Vector2(p.x * tileSize, p.y * tileSize)).toList();
  }
}
