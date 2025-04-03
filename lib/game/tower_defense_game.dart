import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'npcs/basic_npc.dart';
import 'npcs/fast_npc.dart';
import 'npcs/tank_npc.dart';
import 'npcs/npc_base.dart';
import 'towers/basic_tower.dart';
import 'towers/tower_base.dart';

class TowerDefenseGame extends FlameGame with HasCollisionDetection {
  TiledComponent? map;
  List<Vector2> enemyPath = [];
  final List<NPCBase> npcs = [];
  final List<TowerBase> towers = [];
  double baseHealth = 100.0;

  @override
  Future<void> onLoad() async {
    await _loadMap();
    if (map?.tileMap.getLayer<ObjectGroup>('path') == null) {
      print('❌ Path layer missing in JSON map file');
      return;
    }
    enemyPath = _loadEnemyPath();
    _spawnAllNPCs();
    _addInitialTowers();
    await super.onLoad();
  }

  Future<void> _loadMap() async {
    try {
      final loadedMap = await TiledComponent.load('maps/level1.json', Vector2.all(32));
      map = loadedMap;
      add(map!);
      print('✅ Map loaded successfully');
    } catch (e) {
      print('❌ Failed to load map: $e');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final npc in List<NPCBase>.from(npcs)) {
      npc.followPath(dt);
      if (npc.currentPointIndex >= enemyPath.length) {
        _damageBase(npc.baseDamage);
        npc.removeFromParent();
        npcs.remove(npc);
      }
    }
    for (final tower in towers) {
      tower.checkAndShoot(npcs);
    }
    if (baseHealth <= 0) {
      print('Game Over! Base destroyed.');
      pauseEngine();
    }
  }

  List<Vector2> _loadEnemyPath() {
    final pathLayer = map?.tileMap.getLayer<ObjectGroup>('path');
    final pathPoints = <Vector2>[];
    for (final obj in pathLayer?.objects ?? []) {
      pathPoints.add(Vector2(obj.x, obj.y));
    }
    return pathPoints;
  }

  void _spawnAllNPCs() {
    _spawnBasicNPC();
    _spawnFastNPC();
    _spawnTankNPC();
  }

  void _spawnBasicNPC() {
    final npc = BasicNPC(
      path: enemyPath,
      position: enemyPath.first,
      baseDamage: 10.0,
      health: 100.0,
    );
    add(npc);
    npcs.add(npc);
  }

  void _spawnFastNPC() {
    final npc = FastNPC(
      path: enemyPath,
      position: enemyPath.first,
      baseDamage: 5.0,
      health: 75.0,
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
    final towerPositions = _loadTowerSpots();
    for (final pos in towerPositions) {
      final tower = BasicTower(position: pos);
      add(tower);
      towers.add(tower);
    }
  }

  List<Vector2> _loadTowerSpots() {
    final spotsLayer = map?.tileMap.getLayer<ObjectGroup>('tower_spots');
    final spotsPoints = <Vector2>[];
    for (final obj in spotsLayer?.objects ?? []) {
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
    _spawnAllNPCs();
    _addInitialTowers();
    resumeEngine();
    print('Game restarted!');
  }

  void upgradeTower(TowerBase tower) {
    if (tower.upgradeLevel < 4) {
      tower.upgrade();
      print('Tower upgraded to level ${tower.upgradeLevel}');
    } else {
      _chooseTier4Upgrade(tower);
    }
  }

  void _chooseTier4Upgrade(TowerBase tower) {
    print('Choose a Tier 4 upgrade for this tower:');
    print('1. Double Shot');
    print('2. Explosive Rounds');
    print('3. Freeze Effect');
    int choice = 1;
    tower.applyTier4Choice(choice);
    print('Tier 4 upgrade applied!');
  }
}
