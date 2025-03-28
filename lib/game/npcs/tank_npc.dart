import 'package:flame/components.dart';
import '../tower_defense_game.dart';
import 'npc_base.dart';

class TankNPC extends NPCBase {
  double baseDamage;
  bool reachedBase = false;
  double health;

  TankNPC({
    required List<Vector2> path,
    this.baseDamage = 20.0,
    this.health = 200.0,
    Vector2? position,
    Sprite? sprite,
  }) : super(path: path, speed: 25.0, position: position, sprite: sprite);

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
    game.baseHealth -= baseDamage;
    if (game.baseHealth <= 0) {
      print('Game Over! The base has been destroyed!');
    }
  }

  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) {
      removeFromParent();
    }
  }
}
