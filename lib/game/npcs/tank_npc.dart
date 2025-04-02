import 'package:flame/components.dart';
import '../tower_defense_game.dart';
import 'npc_base.dart';

class TankNPC extends NPCBase {
  bool reachedBase = false;

  TankNPC({
    required super.path,
    super.baseDamage = 20.0,
    super.health = 200.0,
    Vector2? position,
    Sprite? sprite,
  }) : super(
          speed: 25.0,
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
    game.baseHealth -= baseDamage;
    if (game.baseHealth <= 0) {
      print('Game Over! The base has been destroyed!');
      game.pauseEngine(); // Stop the game if base health is 0
    }
  }
}
