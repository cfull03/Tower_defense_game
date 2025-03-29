import '../tower_defense_game.dart';
import 'npc_base.dart';

class BasicNPC extends NPCBase {
  double baseDamage;
  bool reachedBase = false;

  BasicNPC({
    required super.path,
    this.baseDamage = 10.0,
    super.position,
    super.sprite,
  });

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

    print('Basic NPC reached the base! Dealing $baseDamage damage!');
    game.baseHealth -= baseDamage;

    if (game.baseHealth <= 0) {
      print('Game Over! The base has been destroyed!');
    }
  }
}
