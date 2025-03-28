import 'package:flame/components.dart';
import '../tower_defense_game.dart';
import 'npc_base.dart';

class FastNPC extends NPCBase {
  double baseDamage;
  bool reachedBase = false;

  FastNPC({
    required List<Vector2> path,
    this.baseDamage = 5.0, 
    Vector2? position,
    Sprite? sprite,
  }) : super(path: path, speed: 100.0, position: position, sprite: sprite);

  @override
  void performAction() {
    if (currentPointIndex >= path.length && !reachedBase) {
      _dealDamageToBase();
      reachedBase = true;
      removeFromParent();
    }
  }

  void _dealDamageToBase() {
    final game = gameRef as TowerDefenseGame;

    print('Fast NPC reached the base! Dealing $baseDamage damage!');
    game.baseHealth -= baseDamage;

    if (game.baseHealth <= 0) {
      print('Game Over! The base has been destroyed!');
    }
  }
}
