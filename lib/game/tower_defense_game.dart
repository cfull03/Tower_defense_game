import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/tiled.dart';
import 'enemies/basic_enemy.dart';
import 'towers/basic_tower.dart';

class TowerDefenseGame extends FlameGame with HasDraggableComponents, HasCollisionDetection {
  late TiledComponent map;
  late List<Vector2> enemyPath;
  final List<BasicEnemy> enemies = [];
  final List<BasicTower> towers = [];

  @override
  Future<void> onLoad() async {
    // Load the map
    map = await TiledComponent.load('level1.tmx', Vector2.all(32));
    add(map);

    // Parse enemy path from Tiled map
    enemyPath = _loadEnemyPath(map);

    // Add initial enemies and towers
    _spawnEnemy();
    _addInitialTowers();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update game logic
    for (var enemy in enemies) {
      enemy.followPath(enemyPath, dt);
      if (enemy.isDead) {
        enemies.remove(enemy);
      }
    }

    for (var tower in towers) {
      tower.checkAndShoot(enemies);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Optional: Draw debug info or HUD
  }

  List<Vector2> _loadEnemyPath(TiledComponent map) {
    final pathLayer = map.tileMap.getLayer<ObjectGroup>('path');
    final pathPoints = <Vector2>[];

    for (final obj in pathLayer!.objects) {
      pathPoints.add(Vector2(obj.x, obj.y));
    }
    return pathPoints;
  }

  void _spawnEnemy() {
    final enemy = BasicEnemy(position: enemyPath.first);
    add(enemy);
    enemies.add(enemy);
  }

  void _addInitialTowers() {
    final towerPositions = [
      Vector2(100, 200),
      Vector2(300, 400),
    ];
    for (var pos in towerPositions) {
      final tower = BasicTower(position: pos);
      add(tower);
      towers.add(tower);
    }
  }

  void addTower(Vector2 position) {
    final tower = BasicTower(position: position);
    add(tower);
    towers.add(tower);
  }
}
