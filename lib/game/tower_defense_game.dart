// tower_defense_game.dart

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'maps/level1_map.dart';
import 'npcs/basic_npc.dart';
import 'npcs/fast_npc.dart';
import 'npcs/tank_npc.dart';
import 'npcs/npc_base.dart';
import 'towers/basic_tower.dart';
import 'towers/tower_base.dart';

class TowerDefenseGame extends FlameGame
    with HasCollisionDetection, HasTappables, TapCallbacks, PanDetector {
  final List<NPCBase> npcs = [];
  final List<TowerBase> towers = [];
  final Level1Map levelMap = Level1Map();
  double baseHealth = 100.0;
  double volume = 0.5;
  String difficulty = 'Normal';
  double difficultyMultiplier = 1.0;
  SpriteComponent? ghostTower;
  TextComponent? statusText;

  @override
  Future<void> onLoad() async {
    await _loadSettings();
    await _renderMap();
    _spawnAllNPCs();
    _addInitialTowers();
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));
    camera.followVector2(Vector2(0, 0));

    final sprite = await loadSprite('towers/basic_tower.png');
    ghostTower = SpriteComponent(
      sprite: sprite,
      size: Vector2.all(32),
      opacity: 0.5,
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
      case Level1Map.dirt:
        return Sprite(image, srcPosition: Vector2(32, 0), srcSize: Vector2(32, 32));
      case Level1Map.flower:
        return Sprite(image, srcPosition: Vector2(64, 0), srcSize: Vector2(32, 32));
      case Level1Map.pathTile:
        return Sprite(image, srcPosition: Vector2(0, 32), srcSize: Vector2(32, 32));
      case Level1Map.river:
        return Sprite(image, srcPosition: Vector2(32, 32), srcSize: Vector2(32, 32));
      case Level1Map.grass:
      default:
        return Sprite(image, srcPosition: Vector2(0, 0), srcSize: Vector2(32, 32));
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    final tapPos = event.canvasPosition;
    for (final spot in levelMap.towerSpots) {
      if (spot.distanceTo(tapPos) < 16) {
        addTower(spot);
        break;
      }
    }
  }

  @override
  void onTapMove(TapMoveEvent event) {
    ghostTower?.position = event.canvasPosition - ghostTower!.size / 2;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.moveBy(-info.delta.game);
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final npc in List<NPCBase>.from(npcs)) {
      npc.followPath(dt);
      if (npc.currentPointIndex >= levelMap.path.length) {
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

  void _spawnAllNPCs() {
    _spawnBasicNPC();
    _spawnFastNPC();
    _spawnTankNPC();
  }

  void _spawnBasicNPC() {
    final npc = BasicNPC(
      path: levelMap.path,
      position: levelMap.path.first,
      baseDamage: 10.0 * difficultyMultiplier,
      health: 100.0 * difficultyMultiplier,
    )..speed *= difficultyMultiplier;
    add(npc);
    npcs.add(npc);
  }

  void _spawnFastNPC() {
    final npc = FastNPC(
      path: levelMap.path,
      position: levelMap.path.first,
      baseDamage: 5.0 * difficultyMultiplier,
      health: 75.0 * difficultyMultiplier,
    )..speed *= difficultyMultiplier;
    add(npc);
    npcs.add(npc);
  }

  void _spawnTankNPC() {
    final npc = TankNPC(
      path: levelMap.path,
      position: levelMap.path.first,
      baseDamage: 20.0 * difficultyMultiplier,
      health: 200.0 * difficultyMultiplier,
    )..speed *= difficultyMultiplier;
    add(npc);
    npcs.add(npc);
  }

  void _addInitialTowers() {
    for (final pos in levelMap.towerSpots) {
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
      print('Tower upgraded to level \${tower.upgradeLevel}');
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
