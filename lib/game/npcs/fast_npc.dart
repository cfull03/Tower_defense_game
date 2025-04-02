import 'package:flame/components.dart';
import '../tower_defense_game.dart';
import 'npc_base.dart';

class FastNPC extends NPCBase {
  bool reachedBase = false;

  FastNPC({
    required super.path,
    super.baseDamage = 5.0,
    super.health = 50.0,
    Vector2? position,
    Sprite? sprite,
  }) : super(
          speed: 100.0,
          position: position ?? Vector2.zero(),
        );

  @override
  void update(double dt) {
    super.update(dt);
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
      game.pauseEngine();
    }
  }
}
