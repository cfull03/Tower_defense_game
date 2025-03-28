import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/tiled.dart';
import 'npcs/basic_npc.dart';
import 'towers/basic_tower.dart';

class TowerDefenseGame extends FlameGame
    with HasDraggableComponents, HasCollisionDetection {
  late TiledComponent map;
  late List<Vector2> enemyPath;
  final List<BasicNPC> npcs = []; // Updated to use NPCs
  final List<BasicTower> towers = [];
  double baseHealth = 100.0; // Added base health

  @override
  Future<void> onLoad() async {
    // Load the map
    map = await TiledComponent.load('level1.tmx', Vector2.all(32));
    add(map);

    // Parse enemy path from Tiled map
    enemyPath = _loadEnemyPath(map);

    // Add initial NPCs and towers
    _spawnNPC();
    _addInitialTowers();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update NPCs and check if they reached the base
    for (var npc in List.from(npcs)) {
      npc.followPath(dt);
      if (npc.currentPointIndex >= enemyPath.length) {
        _damageBase(npc.baseDamage);
        npc.removeFromParent();
        npcs.remove(npc);
      }
    }

    // Towers check and shoot at NPCs
    for (var tower in towers) {
      tower.checkAndShoot(npcs);
    }

    // Check for game over
    if (baseHealth <= 0) {
      print('Game Over! Base destroyed.');
      pauseEngine(); // Stop the game if the base is destroyed
    }
  }

  /// Load enemy path from the Tiled map
  List<Vector2> _loadEnemyPath(TiledComponent map) {
    final pathLayer = map.tileMap.getLayer<ObjectGroup>('path');
    final pathPoints = <Vector2>[];

    for (final obj in pathLayer!.objects) {
      pathPoints.add(Vector2(obj.x, obj.y));
    }
    return pathPoints;
  }

  /// Spawn a Basic NPC at the start of the path
  void _spawnNPC() {
    final npc = BasicNPC(
      path: enemyPath,
      position: enemyPath.first,
      baseDamage: 10.0, // Base damage when reaching the end
    );
    add(npc);
    npcs.add(npc);
  }

  /// Add initial towers at predefined positions
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

  /// Reduce base health when NPC reaches the target
  void _damageBase(double damage) {
    baseHealth -= damage;
    print('Base took $damage damage! Health remaining: $baseHealth');
  }
}
