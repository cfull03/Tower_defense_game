import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/tiled.dart';
import 'npcs/basic_npc.dart';
import 'npcs/fast_npc.dart';
import 'npcs/tank_npc.dart';
import 'towers/basic_tower.dart';

class TowerDefenseGame extends FlameGame
    with HasDraggableComponents, HasCollisionDetection {
  late TiledComponent map;
  late List<Vector2> enemyPath;
  final List<BasicNPC> npcs = [];
  final List<BasicTower> towers = [];
  double baseHealth = 100.0;

  @override
  Future<void> onLoad() async {
    await _loadMap();
    enemyPath = _loadEnemyPath(map);
    _spawnBasicNPC();
    _spawnFastNPC();
    _spawnTankNPC();
    _addInitialTowers();
    return super.onLoad();
  }

  Future<void> _loadMap() async {
    map = await TiledComponent.load('level1.tmx', Vector2.all(32));
    add(map);
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (var npc in List.from(npcs)) {
      npc.followPath(dt);
      if (npc.currentPointIndex >= enemyPath.length) {
        _damageBase(npc.baseDamage);
        npc.removeFromParent();
        npcs.remove(npc);
      }
    }
    for (var tower in towers) {
      tower.checkAndShoot(npcs);
    }
    if (baseHealth <= 0) {
      print('Game Over! Base destroyed.');
      pauseEngine();
    }
  }

  List<Vector2> _loadEnemyPath(TiledComponent map) {
    final pathLayer = map.tileMap.getLayer<ObjectGroup>('path');
    final pathPoints = <Vector2>[];
    for (final obj in pathLayer!.objects) {
      pathPoints.add(Vector2(obj.x, obj.y));
    }
    return pathPoints;
  }

  void _spawnBasicNPC() {
    final npc = BasicNPC(
      path: enemyPath,
      position: enemyPath.first,
      baseDamage: 10.0,
    );
    add(npc);
    npcs.add(npc);
  }

  void _spawnFastNPC() {
    final npc = FastNPC(
      path: enemyPath,
      position: enemyPath.first,
      baseDamage: 5.0,
    );
    add(npc);
    npcs.add(npc);
  }

  void _spawnTankNPC() {
    final npc = TankNPC(
      path: enemyPath,
      position: enemyPath.first,
      baseDamage: 20.0,
      health: 200.0,
    );
    add(npc);
    npcs.add(npc);
  }

  void _addInitialTowers() {
    final towerPositions = _loadTowerSpots(map);
    for (var pos in towerPositions) {
      final tower = BasicTower(position: pos);
      add(tower);
      towers.add(tower);
    }
  }

  List<Vector2> _loadTowerSpots(TiledComponent map) {
    final spotsLayer = map.tileMap.getLayer<ObjectGroup>('tower_spots');
    final spotsPoints = <Vector2>[];
    for (final obj in spotsLayer!.objects) {
      spotsPoints.add(Vector2(obj.x, obj.y));
    }
    return spotsPoints;
  }

  void addTower(Vector2 position) {
    final tower = BasicTower(position: position);
    add(tower);
    towers.add(tower);
  }

  void _damageBase(double damage) {
    baseHealth -= damage;
    print('Base took $damage damage! Health remaining: $baseHealth');
  }

  void restartGame() {
    removeAll(npcs);
    removeAll(towers);
    npcs.clear();
    towers.clear();
    baseHealth = 100.0;
    _spawnBasicNPC();
    _spawnFastNPC();
    _spawnTankNPC();
    _addInitialTowers();
    resumeEngine();
    print('Game restarted!');
  }
}
